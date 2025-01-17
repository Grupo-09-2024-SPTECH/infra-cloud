DROP DATABASE adoptaidb;
CREATE DATABASE adoptaidb;

USE adoptaidb;

CREATE TABLE IF NOT EXISTS `tb_desempenho` (
	`id_desempenho` int AUTO_INCREMENT NOT NULL,
	`fk_execucao` int NOT NULL,
	`tp_classe` int NOT NULL,
	`vl_precision` decimal(10,3) NOT NULL,
	`vl_recall` decimal(10,3) NOT NULL,
	`vl_f1_score` decimal(10,3) NOT NULL,
	PRIMARY KEY (`id_desempenho`)
);

CREATE TABLE IF NOT EXISTS `tb_execucao` (
	`id_execucao` int AUTO_INCREMENT NOT NULL,
	`fk_modelo` int NOT NULL,
	`vl_accuracy` decimal(10,3) NOT NULL,
	`vl_mae` decimal(10,3) NOT NULL,
	`vl_qwk` decimal(10,3) NOT NULL,
	`dt_inicio_exec` datetime NOT NULL,
	`dt_fim_exec` datetime NOT NULL,
	PRIMARY KEY (`id_execucao`)
);

CREATE TABLE IF NOT EXISTS `tb_hiperparametro` (
	`id_parametro` int AUTO_INCREMENT NOT NULL,
	`fk_execucao` int NOT NULL,
	`nome_parametro` varchar(255) NOT NULL,
	`vl_parametro` decimal(10,3) NOT NULL,
	PRIMARY KEY (`id_parametro`)
);

CREATE TABLE IF NOT EXISTS `tb_modelo` (
	`id_modelo` int AUTO_INCREMENT NOT NULL,
	`nome_modelo` varchar(255) NOT NULL,
	`nome_base` varchar(255) NOT NULL,
	PRIMARY KEY (`id_modelo`)
);

CREATE OR REPLACE VIEW vw_modelo_desempenho AS
SELECT
a.id_modelo,
b.id_execucao,
a.nome_modelo,
a.nome_base,
c.nome_parametro,
c.vl_parametro,
b.dt_inicio_exec,
b.dt_fim_exec,
b.vl_accuracy,
b.vl_mae,
b.vl_qwk,
d.tp_classe,
d.vl_precision,
d.vl_recall,
d.vl_f1_score
FROM tb_modelo AS a
LEFT JOIN tb_execucao AS b ON a.id_modelo = b.fk_modelo
LEFT JOIN tb_hiperparametro AS c ON c.fk_execucao = b.id_execucao
LEFT JOIN tb_desempenho AS d ON d.fk_execucao = b.id_execucao;

ALTER TABLE `tb_desempenho` ADD CONSTRAINT `tb_desempenho_fk1` FOREIGN KEY (`fk_execucao`) REFERENCES `tb_execucao`(`id_execucao`);
ALTER TABLE `tb_execucao` ADD CONSTRAINT `tb_execucao_fk1` FOREIGN KEY (`fk_modelo`) REFERENCES `tb_modelo`(`id_modelo`);
ALTER TABLE `tb_hiperparametro` ADD CONSTRAINT `tb_hiperparametro_fk1` FOREIGN KEY (`fk_execucao`) REFERENCES `tb_execucao`(`id_execucao`);