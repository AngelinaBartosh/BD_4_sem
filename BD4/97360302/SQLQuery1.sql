CREATE DATABASE Склад_302
ON PRIMARY
  ( NAME = Склад_data,
    FILENAME = 'D:\2 courses\4 сем\BD\ВD4\97360302\Склад_302_data.ndf',
    SIZE = 5MB,
    MAXSIZE = 75MB,
    FILEGROWTH = 3MB),
    FILEGROUP Secondary
  (NAME = Склад2_data,
    FILENAME = 'D:\2 courses\4 сем\BD\ВD4\97360302\Склад_302_data2.ndf',
    SIZE = 3MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%),
  (NAME = Склад3_data,
    FILENAME = 'D:\2 courses\4 сем\BD\ВD4\97360302\Склад_302_data3.ndf',
    SIZE = 4MB,
    FILEGROWTH = 4MB)
LOG ON 
  (NAME = Склад_log,
    FILENAME = 'D:\2 courses\4 сем\BD\ВD4\97360302\Склад_302_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 20%),
  (NAME = Склад2_log,
    FILENAME = 'D:\2 courses\4 сем\BD\ВD4\97360302\Склад_302_log2.ldf',
    SIZE = 512KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 10%)
GO

USE Склад_302
GO

CREATE RULE Logical_rule AS @value IN ('Нет','Да')
GO

CREATE DEFAULT Logical_deault AS 'Нет'
GO

EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'
GO

EXEC sp_bindrule 'Logical_rule', 'Logical'
GO

EXEC sp_bindefault 'Logical_default', 'Logical'
GO

/*Регион*/
CREATE TABLE Регион ( /* первая команда пакета */
    КодРегиона INT PRIMARY KEY,
    Страна VARCHAR(20) DEFAULT 'Беларусь' NOT NULL,
    Область VARCHAR(20) NOT NULL,
    Город VARCHAR(20) NOT NULL,
    Адрес VARCHAR(50) NOT NULL,
    Телефон CHAR(15) NULL,
    Факс CHAR(15) NOT NULL CONSTRAINT CIX_Регион2
     UNIQUE ON Secondary,
    CONSTRAINT CIX_Регион UNIQUE (Страна, Область, Город, Адрес)
     ON Secondary
)

/* Поставщик */
CREATE TABLE Поставщик ( /* вторая команда пакета */
    КодПоставщика INT PRIMARY KEY,
    ИмяПоставщика VARCHAR(40) NOT NULL,
    УсловияОплаты VARCHAR(30) DEFAULT 'Предоплата' NULL,
    КодРегиона INT NULL,
    Заметки VARCHAR(MAX) NULL,
    CONSTRAINT FK_Поставщик_Регион FOREIGN KEY (КодРегиона)
     REFERENCES Регион ON UPDATE CASCADE
)

/* Клиент */
CREATE TABLE Клиент ( /* третья команда пакета */
    КодКлиента INT IDENTITY(1,1) PRIMARY KEY,
    ИмяКлиента VARCHAR(40) NOT NULL,
    ФИОРуководителя VARCHAR(60) NULL,
    КодРегиона INT NULL,
    CONSTRAINT FK_Клиент_Регион FOREIGN KEY (КодРегиона)
     REFERENCES Регион ON UPDATE CASCADE
)

/* Валюта */
CREATE TABLE Валюта ( /* четвертая команда пакета */
    КодВалюты CHAR(3) PRIMARY KEY,
    ИмяВалюты VARCHAR(30) NOT NULL,
    ШагОкругления NUMERIC(10, 4) DEFAULT 0.01 NULL
     CHECK (ШагОкругления IN (50, 1, 0.01)),
    КурсВалюты SMALLMONEY NOT NULL CHECK (КурсВалюты > 0)
)

/* Товар */
CREATE TABLE Товар ( /* пятая команда пакета */
    КодТовара INT PRIMARY KEY,
    Наименование VARCHAR(50) NOT NULL,
    ЕдиницаИзм CHAR(10) DEFAULT 'штука' NULL,
    Цена MONEY NULL CHECK (Цена > 0),
    КодВалюты CHAR(3) DEFAULT 'BYR' NULL,
    Расфасован LOGICAL NOT NULL,
    CONSTRAINT FK_Товар_Валюта FOREIGN KEY (КодВалюты)
     REFERENCES Валюта ON UPDATE CASCADE
)

/* Заказ */
CREATE TABLE Заказ ( /* шестая команда пакета */
    КодЗаказа INT IDENTITY(1,1) NOT NULL,
    КодКлиента INT NOT NULL,
    КодТовара INT NOT NULL,
    Количество NUMERIC(12, 3) NULL CHECK (Количество > 0),
    ДатаЗаказа DATETIME DEFAULT getdate() NULL,
    СрокПоставки DATETIME DEFAULT getdate() + 14 NULL,
    КодПоставщика INT NULL,
    PRIMARY KEY (КодЗаказа, КодКлиента, КодТовара),
    CONSTRAINT FK_Заказ_Товар FOREIGN KEY (КодТовара)
     REFERENCES Товар ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Заказ_Клиент FOREIGN KEY (КодКлиента)
     REFERENCES Клиент ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Заказ_Поставщик FOREIGN KEY (КодПоставщика)
     REFERENCES Поставщик
)
GO

CREATE UNIQUE INDEX UIX_Поставщик ON Поставщик (ИмяПоставщика)
    ON Secondary
CREATE UNIQUE INDEX UIX_Клиент ON Клиент (ИмяКлиента)
    ON Secondary
CREATE UNIQUE INDEX UIX_Валюта ON Валюта (ИмяВалюты)
    ON Secondary
CREATE UNIQUE INDEX UIX_Товар ON Товар (Наименование)
    ON Secondary
CREATE INDEX IX_Регион ON Регион (Страна, Город) ON Secondary
CREATE INDEX IX_Товар ON Товар (ЕдиницаИзм, Наименование)
    ON Secondary
CREATE INDEX IX_Заказ ON Заказ (ДатаЗаказа) ON Secondary
GO