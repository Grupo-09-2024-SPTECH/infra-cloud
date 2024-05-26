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

CREATE TABLE IF NOT EXISTS `vw_modelo_desempenho` (
	`id_modelo` int NOT NULL,
	`id_execucao` int NOT NULL,
	`id_parametro` int NOT NULL,
	`id_desempenho` int NOT NULL,
	`nome_modelo` varchar(255) NOT NULL,
	`nome_parametro` varchar(255) NOT NULL,
	`tp_classe` int NOT NULL,
	`vl_accuracy` decimal(10,3) NOT NULL,
	`vl_parametro` decimal(10,3) NOT NULL,
	`vl_precision` decimal(10,3) NOT NULL,
	`vl_recall` decimal(10,3) NOT NULL,
	`vl_f1_score` decimal(10,3) NOT NULL,
	`dt_inicio_exec` datetime NOT NULL,
	`dt_fim_exec` datetime NOT NULL
);

ALTER TABLE `tb_desempenho` ADD CONSTRAINT `tb_desempenho_fk1` FOREIGN KEY (`fk_execucao`) REFERENCES `tb_execucao`(`id_execucao`);
ALTER TABLE `tb_execucao` ADD CONSTRAINT `tb_execucao_fk1` FOREIGN KEY (`fk_modelo`) REFERENCES `tb_modelo`(`id_modelo`);
ALTER TABLE `tb_hiperparametro` ADD CONSTRAINT `tb_hiperparametro_fk1` FOREIGN KEY (`fk_execucao`) REFERENCES `tb_execucao`(`id_execucao`);