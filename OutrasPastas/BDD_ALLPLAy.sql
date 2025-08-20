USE PI_BBD;

-- Criação da tabela de Localização, que é referenciada por outras tabelas
CREATE TABLE Localizacao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cidade VARCHAR(255),
    estado VARCHAR(255),
    pais VARCHAR(255),
    latitude DOUBLE,
    longitude DOUBLE
);

-- Criação da tabela de Usuário, a superclasse
CREATE TABLE Usuario (
    CPF VARCHAR(14) PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    bio TEXT,
    fotoDePerfil VARCHAR(255),
    localizacaoAtual_id INT,
    FOREIGN KEY (localizacaoAtual_id) REFERENCES Localizacao(id) ON DELETE SET NULL
);

-- Criação da tabela de Atleta, subclasse de Usuario
CREATE TABLE Atleta (
    CPF VARCHAR(14) PRIMARY KEY NOT NULL,
    IDatleta INT UNIQUE AUTO_INCREMENT,
    FOREIGN KEY (CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Administrador, subclasse de Usuario
CREATE TABLE Administrador (
    CPF VARCHAR(14) PRIMARY KEY NOT NULL,
    IDadm INT UNIQUE AUTO_INCREMENT,
    FOREIGN KEY (CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Professor, subclasse de Usuario
CREATE TABLE Professor (
    CPF VARCHAR(14) PRIMARY KEY NOT NULL,
    IDprofessor INT UNIQUE AUTO_INCREMENT,
    FOREIGN KEY (CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Esporte
CREATE TABLE Esporte (
    nome VARCHAR(255) PRIMARY KEY,
    IDesporte INT UNIQUE AUTO_INCREMENT,
    categoria ENUM('Individual', 'Coletivo')
);

-- Tabela de relacionamento para os esportes de interesse do usuário
CREATE TABLE Usuario_EsportesDeInteresse (
    CPF_usuario VARCHAR(14) NOT NULL,
    nome_esporte VARCHAR(255) NOT NULL,
    PRIMARY KEY (CPF_usuario, nome_esporte),
    FOREIGN KEY (CPF_usuario) REFERENCES Usuario(CPF) ON DELETE CASCADE,
    FOREIGN KEY (nome_esporte) REFERENCES Esporte(nome) ON DELETE CASCADE
);

-- Tabela de relacionamento para seguir/seguidores
CREATE TABLE Seguidores (
    CPF_seguidor VARCHAR(14) NOT NULL,
    CPF_seguido VARCHAR(14) NOT NULL,
    PRIMARY KEY (CPF_seguidor, CPF_seguido),
    FOREIGN KEY (CPF_seguidor) REFERENCES Usuario(CPF) ON DELETE CASCADE,
    FOREIGN KEY (CPF_seguido) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Clube
CREATE TABLE Clube (
    IDclube INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    localizacao_id INT,
    FOREIGN KEY (localizacao_id) REFERENCES Localizacao(id) ON DELETE SET NULL
);

-- Tabela de relacionamento para os esportes de um clube
CREATE TABLE Clube_Esportes (
    IDclube INT NOT NULL,
    nome_esporte VARCHAR(255) NOT NULL,
    PRIMARY KEY (IDclube, nome_esporte),
    FOREIGN KEY (IDclube) REFERENCES Clube(IDclube) ON DELETE CASCADE,
    FOREIGN KEY (nome_esporte) REFERENCES Esporte(nome) ON DELETE CASCADE
);

-- Criação da tabela de Publicacao
CREATE TABLE Publicacao (
    IDpublicacao INT PRIMARY KEY AUTO_INCREMENT,
    data_publicacao DATE,
    conteudo TEXT,
    autor_CPF VARCHAR(14) NOT NULL,
    FOREIGN KEY (autor_CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Comentario
CREATE TABLE Comentario (
    IDcomentario INT PRIMARY KEY AUTO_INCREMENT,
    conteudo TEXT,
    horario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    autor_CPF VARCHAR(14) NOT NULL,
    IDpublicacao INT NOT NULL,
    FOREIGN KEY (autor_CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE,
    FOREIGN KEY (IDpublicacao) REFERENCES Publicacao(IDpublicacao) ON DELETE CASCADE
);

-- Criação da tabela de Mensagem
CREATE TABLE Mensagem (
    IDmensagem INT PRIMARY KEY AUTO_INCREMENT,
    conteudo TEXT,
    horario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remetente_CPF VARCHAR(14),
    destinatario_CPF VARCHAR(14),
    FOREIGN KEY (remetente_CPF) REFERENCES Usuario(CPF) ON DELETE SET NULL,
    FOREIGN KEY (destinatario_CPF) REFERENCES Usuario(CPF) ON DELETE SET NULL
);

-- Criação da tabela de Notificacao
CREATE TABLE Notificacao (
    IDnotificacao INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    conteudo TEXT,
    remetente_CPF VARCHAR(14),
    destinatario_CPF VARCHAR(14),
    horario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_leitura TIMESTAMP,
    FOREIGN KEY (remetente_CPF) REFERENCES Usuario(CPF) ON DELETE SET NULL,
    FOREIGN KEY (destinatario_CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Denuncia
CREATE TABLE Denuncia (
    IDdenuncia INT PRIMARY KEY AUTO_INCREMENT,
    data_denuncia DATE,
    conteudo TEXT,
    denunciante_CPF VARCHAR(14),
    denunciado_CPF VARCHAR(14),
    FOREIGN KEY (denunciante_CPF) REFERENCES Usuario(CPF) ON DELETE SET NULL,
    FOREIGN KEY (denunciado_CPF) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Grupo
CREATE TABLE Grupo (
    IDgrupo INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    esporte_grupo VARCHAR(255),
    FOREIGN KEY (esporte_grupo) REFERENCES Esporte(nome) ON DELETE SET NULL
);

-- Tabela de relacionamento para os membros de um grupo
CREATE TABLE Grupo_Membros (
    IDgrupo INT NOT NULL,
    CPF_membro VARCHAR(14) NOT NULL,
    PRIMARY KEY (IDgrupo, CPF_membro),
    FOREIGN KEY (IDgrupo) REFERENCES Grupo(IDgrupo) ON DELETE CASCADE,
    FOREIGN KEY (CPF_membro) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Tabela de relacionamento para as mensagens de um grupo
CREATE TABLE Grupo_Mensagens (
    IDgrupo INT NOT NULL,
    IDmensagem INT NOT NULL,
    PRIMARY KEY (IDgrupo, IDmensagem),
    FOREIGN KEY (IDgrupo) REFERENCES Grupo(IDgrupo) ON DELETE CASCADE,
    FOREIGN KEY (IDmensagem) REFERENCES Mensagem(IDmensagem) ON DELETE CASCADE
);

-- Criação da tabela de Conquista
CREATE TABLE Conquista (
    IDconquista INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_conquista DATE,
    conquistado_por VARCHAR(14),
    FOREIGN KEY (conquistado_por) REFERENCES Atleta(CPF) ON DELETE CASCADE
);

-- Criação da tabela de Evento
CREATE TABLE Evento (
    IDevento INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    requisito TEXT,
    localizacao_id INT,
    descricao TEXT,
    horario DATETIME,
    data_evento DATE,
    criador_CPF VARCHAR(14),
    FOREIGN KEY (localizacao_id) REFERENCES Localizacao(id) ON DELETE SET NULL,
    FOREIGN KEY (criador_CPF) REFERENCES Usuario(CPF) ON DELETE SET NULL
);

-- Tabela de relacionamento para os participantes de um evento
CREATE TABLE Evento_Participantes (
    IDevento INT NOT NULL,
    CPF_participante VARCHAR(14) NOT NULL,
    PRIMARY KEY (IDevento, CPF_participante),
    FOREIGN KEY (IDevento) REFERENCES Evento(IDevento) ON DELETE CASCADE,
    FOREIGN KEY (CPF_participante) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Tabela de relacionamento para os confirmados de um evento
CREATE TABLE Evento_Confirmados (
    IDevento INT NOT NULL,
    CPF_confirmado VARCHAR(14) NOT NULL,
    PRIMARY KEY (IDevento, CPF_confirmado),
    FOREIGN KEY (IDevento) REFERENCES Evento(IDevento) ON DELETE CASCADE,
    FOREIGN KEY (CPF_confirmado) REFERENCES Usuario(CPF) ON DELETE CASCADE
);

-- Tabela de relacionamento para os convidados de um evento
CREATE TABLE Evento_Convidados (
    IDevento INT NOT NULL,
    CPF_convidado VARCHAR(14) NOT NULL,
    PRIMARY KEY (IDevento, CPF_convidado),
    FOREIGN KEY (IDevento) REFERENCES Evento(IDevento) ON DELETE CASCADE,
    FOREIGN KEY (CPF_convidado) REFERENCES Usuario(CPF) ON DELETE CASCADE
);