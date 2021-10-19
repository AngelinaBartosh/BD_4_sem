CREATE DATABASE �����_302
ON PRIMARY
  ( NAME = �����_data,
    FILENAME = 'D:\2 courses\4 ���\BD\�D4\97360302\�����_302_data.ndf',
    SIZE = 5MB,
    MAXSIZE = 75MB,
    FILEGROWTH = 3MB),
    FILEGROUP Secondary
  (NAME = �����2_data,
    FILENAME = 'D:\2 courses\4 ���\BD\�D4\97360302\�����_302_data2.ndf',
    SIZE = 3MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%),
  (NAME = �����3_data,
    FILENAME = 'D:\2 courses\4 ���\BD\�D4\97360302\�����_302_data3.ndf',
    SIZE = 4MB,
    FILEGROWTH = 4MB)
LOG ON 
  (NAME = �����_log,
    FILENAME = 'D:\2 courses\4 ���\BD\�D4\97360302\�����_302_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 20%),
  (NAME = �����2_log,
    FILENAME = 'D:\2 courses\4 ���\BD\�D4\97360302\�����_302_log2.ldf',
    SIZE = 512KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 10%)
GO

USE �����_302
GO

CREATE RULE Logical_rule AS @value IN ('���','��')
GO

CREATE DEFAULT Logical_deault AS '���'
GO

EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'
GO

EXEC sp_bindrule 'Logical_rule', 'Logical'
GO

EXEC sp_bindefault 'Logical_default', 'Logical'
GO

/*������*/
CREATE TABLE ������ ( /* ������ ������� ������ */
    ���������� INT PRIMARY KEY,
    ������ VARCHAR(20) DEFAULT '��������' NOT NULL,
    ������� VARCHAR(20) NOT NULL,
    ����� VARCHAR(20) NOT NULL,
    ����� VARCHAR(50) NOT NULL,
    ������� CHAR(15) NULL,
    ���� CHAR(15) NOT NULL CONSTRAINT CIX_������2
     UNIQUE ON Secondary,
    CONSTRAINT CIX_������ UNIQUE (������, �������, �����, �����)
     ON Secondary
)

/* ��������� */
CREATE TABLE ��������� ( /* ������ ������� ������ */
    ������������� INT PRIMARY KEY,
    ������������� VARCHAR(40) NOT NULL,
    ������������� VARCHAR(30) DEFAULT '����������' NULL,
    ���������� INT NULL,
    ������� VARCHAR(MAX) NULL,
    CONSTRAINT FK_���������_������ FOREIGN KEY (����������)
     REFERENCES ������ ON UPDATE CASCADE
)

/* ������ */
CREATE TABLE ������ ( /* ������ ������� ������ */
    ���������� INT IDENTITY(1,1) PRIMARY KEY,
    ���������� VARCHAR(40) NOT NULL,
    ��������������� VARCHAR(60) NULL,
    ���������� INT NULL,
    CONSTRAINT FK_������_������ FOREIGN KEY (����������)
     REFERENCES ������ ON UPDATE CASCADE
)

/* ������ */
CREATE TABLE ������ ( /* ��������� ������� ������ */
    ��������� CHAR(3) PRIMARY KEY,
    ��������� VARCHAR(30) NOT NULL,
    ������������� NUMERIC(10, 4) DEFAULT 0.01 NULL
     CHECK (������������� IN (50, 1, 0.01)),
    ���������� SMALLMONEY NOT NULL CHECK (���������� > 0)
)

/* ����� */
CREATE TABLE ����� ( /* ����� ������� ������ */
    ��������� INT PRIMARY KEY,
    ������������ VARCHAR(50) NOT NULL,
    ���������� CHAR(10) DEFAULT '�����' NULL,
    ���� MONEY NULL CHECK (���� > 0),
    ��������� CHAR(3) DEFAULT 'BYR' NULL,
    ���������� LOGICAL NOT NULL,
    CONSTRAINT FK_�����_������ FOREIGN KEY (���������)
     REFERENCES ������ ON UPDATE CASCADE
)

/* ����� */
CREATE TABLE ����� ( /* ������ ������� ������ */
    ��������� INT IDENTITY(1,1) NOT NULL,
    ���������� INT NOT NULL,
    ��������� INT NOT NULL,
    ���������� NUMERIC(12, 3) NULL CHECK (���������� > 0),
    ���������� DATETIME DEFAULT getdate() NULL,
    ������������ DATETIME DEFAULT getdate() + 14 NULL,
    ������������� INT NULL,
    PRIMARY KEY (���������, ����������, ���������),
    CONSTRAINT FK_�����_����� FOREIGN KEY (���������)
     REFERENCES ����� ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_�����_������ FOREIGN KEY (����������)
     REFERENCES ������ ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_�����_��������� FOREIGN KEY (�������������)
     REFERENCES ���������
)
GO

CREATE UNIQUE INDEX UIX_��������� ON ��������� (�������������)
    ON Secondary
CREATE UNIQUE INDEX UIX_������ ON ������ (����������)
    ON Secondary
CREATE UNIQUE INDEX UIX_������ ON ������ (���������)
    ON Secondary
CREATE UNIQUE INDEX UIX_����� ON ����� (������������)
    ON Secondary
CREATE INDEX IX_������ ON ������ (������, �����) ON Secondary
CREATE INDEX IX_����� ON ����� (����������, ������������)
    ON Secondary
CREATE INDEX IX_����� ON ����� (����������) ON Secondary
GO