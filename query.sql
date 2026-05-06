CREATE TRIGGER check_admin_before_insert
BEFORE INSERT ON QUESTOES
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE tipo_usuario VARCHAR(50);

    -- Assumindo que você tem uma função que retorna o tipo de usuário baseado no ID
    SET tipo_usuario = (SELECT TIPO FROM USUARIO WHERE idUSUARIO = NEW.USUARIO_idUSUARIO);

    IF tipo_usuario != 'Administrador' THEN
        SET msg = 'Operação INSERT permitida apenas para Administradores';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;

-- Administrador
INSERT INTO USUARIO (idUSUARIO, NICK, NOME_USU, SENHA, TIPO) 
VALUES (1, 'admin_nick', 'admin_nome', 'admin_senha', 'Administrador');
-- Jogador
INSERT INTO USUARIO (idUSUARIO, NICK, NOME_USU, SENHA, TIPO) 
VALUES (2, 'jogador_nick', 'jogador_nome', 'jogador_senha', 'Jogador');
-- Questão
INSERT INTO QUESTOES (idQuestoes, USUARIO_idUSUARIO, DESCRICAO) 
VALUES (1, 1, 'Qual é a capital do Rio de Janeiro?');

UPDATE QUESTOES 
SET DESCRICAO = 'Qual é a capital de São Paulo?'
WHERE idQuestoes = 1;

SELECT U.NICK, J.DATA_jogo, J.TOTAL_PONTOS 
FROM JOGOS J
JOIN USUARIO U
ON J.USUARIO_idUSUARIO = U.idUSUARIO
ORDER BY J.TOTAL_PONTOS DESC, J.DATA_jogo DESC;

SELECT Q.DESCRICAO AS Questao, A.DESCRICAO AS Alternativa,
       SUM(CASE WHEN A.CORRETA = '0' THEN 1 ELSE 0 END) AS Total_Erros,
       SUM(CASE WHEN A.CORRETA = '1' THEN 1 ELSE 0 END) AS Total_Acertos
FROM RESPOSTAS R
JOIN ALTERNATIVAS A
ON R.Questoes_idQuestoes = A.IDQUESTOES
JOIN QUESTOES Q
ON A.IDQUESTOES = Q.idQuestoes
GROUP BY Q.DESCRICAO, A.DESCRICAO;

SELECT U.NICK, AVG(J.TOTAL_PONTOS) AS Media
FROM JOGOS J
JOIN USUARIO U
ON J.USUARIO_idUSUARIO = U.idUSUARIO
GROUP BY U.NICK;

SELECT U.NOME_USU AS Nome_jogador
FROM USUARIO U
LEFT JOIN JOGOS J
ON U.idUSUARIO = J.USUARIO_idUSUARIO
WHERE J.idJOGO IS NULL AND U.TIPO = 'Jogador';
