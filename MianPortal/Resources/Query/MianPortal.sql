USE master; 

IF EXISTS (
	SELECT * 
	FROM sys.databases 
	WHERE name = N'MianPortal'
) BEGIN 
	DROP DATABASE MianPortal; 
	CREATE DATABASE MianPortal; 
END; 
ELSE BEGIN 
	CREATE DATABASE MianPortal; 
END;

USE MianPortal;

CREATE TABLE AdminUsers (
	UserName CHAR(15) NOT NULL PRIMARY KEY, 
	Password VARCHAR(64) NOT NULL
);
INSERT INTO AdminUsers VALUES('admin', '4AC9F76152B052C43CA10E31ECBA9407F7B2E9F3FC91B17ADEA14979F275B7B8');

CREATE TABLE Users (
	UID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, 
	UFName NVARCHAR(35) NOT NULL, 
	ULName NVARCHAR(15) NOT NULL, 
	UGender INT, 
	UDob DATE NOT NULL, 
	UMobileNo CHAR(15), 
	UEmail VARCHAR(120) NOT NULL 
); 

CREATE TABLE AccountStatus (
	IDStatus SMALLINT NOT NULL PRIMARY KEY, 
	NameStatus NVARCHAR(30) NOT NULL 
); 
INSERT INTO AccountStatus VALUES(0, N'Chưa mở tài khoản dịch vụ');
INSERT INTO AccountStatus VALUES(1, N'Đã mở tài khoản dịch vụ');
INSERT INTO AccountStatus VALUES(2, N'Đã khoá tài khoản dịch vụ');

CREATE TABLE ProvidedServices (
	IDService INT NOT NULL PRIMARY KEY, 
	NameService NVARCHAR(120) NOT NULL
); 
INSERT INTO ProvidedServices VALUES( 1, N'Hosting Web .NET Framework'); 
INSERT INTO ProvidedServices VALUES( 2, N'Hosting Web .NET Core'); 
INSERT INTO ProvidedServices VALUES( 3, N'Hosting Web NodeJS'); 
INSERT INTO ProvidedServices VALUES( 4, N'Hosting Web PHP thuần'); 
INSERT INTO ProvidedServices VALUES( 5, N'Hosting Web Laravel'); 
INSERT INTO ProvidedServices VALUES( 6, N'Truy cập Cơ sở dữ liệu Microsoft SQL Server'); 
INSERT INTO ProvidedServices VALUES( 7, N'Truy cập Cơ sở dữ liệu Oracle MySQL'); 
INSERT INTO ProvidedServices VALUES( 8, N'Truy cập Cơ sở dữ liệu Oracle Enterprise 19c'); 
INSERT INTO ProvidedServices VALUES( 9, N'Truy cập Hệ thống thông tin quản lý Odoo'); 
INSERT INTO ProvidedServices VALUES(10, N'Truy cập FTP riêng tư'); 
INSERT INTO ProvidedServices VALUES(11, N'Truy cập SMB riêng tư'); 
INSERT INTO ProvidedServices VALUES(12, N'Truy cập website quản lý tập tin riêng tư'); 
INSERT INTO ProvidedServices VALUES(13, N'Boot Windows 7/10/11 trực tiếp qua mạng LAN'); 
INSERT INTO ProvidedServices VALUES(14, N'Cài đặt Windows 7/10/11 qua mạng LAN'); 

CREATE TABLE Accounts (
	UserName CHAR(32) NOT NULL PRIMARY KEY, 
	Password VARCHAR(64) NOT NULL, 
	UID INT NOT NULL, 
	IDStatus SMALLINT NOT NULL, 
	FOREIGN KEY(UID) REFERENCES Users(UID), 
	FOREIGN KEY(IDStatus) REFERENCES AccountStatus(IDStatus)
); 

CREATE TABLE ServiceStatus (
	IDStatus SMALLINT NOT NULL PRIMARY KEY, 
	NameStatus NVARCHAR(30) NOT NULL 
);
INSERT INTO ServiceStatus VALUES(1, N'Được truy cập'); 
INSERT INTO ServiceStatus VALUES(0, N'Chưa được truy cập'); 

CREATE TABLE RegisteredServices (
	UserName CHAR(32) NOT NULL, 
	IDService INT NOT NULL, 
	IDStatus SMALLINT NOT NULL, 
	PRIMARY KEY(UserName, IDService), 
	FOREIGN KEY(UserName) REFERENCES Accounts(UserName), 
	FOREIGN KEY(IDService) REFERENCES ProvidedServices(IDService), 
	FOREIGN KEY(IDStatus) REFERENCES ServiceStatus(IDStatus)
);

-- Trigger(s) 
-- 1. Không cho phép xoá tài khoản Quản trị viên 
CREATE TRIGGER tg01_r01 ON AdminUsers
FOR INSERT, UPDATE, DELETE AS BEGIN 
	Rollback Transaction; 
	Raiserror(N'KHÔNG được thao tác tài khoản Quản trị viên!', 16, 1);
END;

--CREATE TABLE AccountFiles (
--	IDFile CHAR(20) NOT NULL PRIMARY KEY, 
--	NameFile NVARCHAR(MAX) NOT NULL, 
--	TypeFile CHAR(16) NOT NULL, 
--	DateUpload DATETIME NOT NULL, 
--	FilePath NVARCHAR(MAX) NOT NULL, 
--	Base64File VARBINARY NOT NULL 
--);

--CREATE TABLE Actions ( 
--	IDAction SMALLINT NOT NULL PRIMARY KEY, 
--	NameAction NVARCHAR(30) NOT NULL 
--); 
--INSERT INTO Actions VALUES(1, N'Tạo mới');
--INSERT INTO Actions VALUES(2, N'Xoá tệp');
--CREATE TABLE FileActionDetails (
--	IDFile CHAR(20) NOT NULL, 
--	UserName CHAR(32) NOT NULL, 
--	IDAction SMALLINT NOT NULL, 
--	PRIMARY KEY(IDFile, UserName), 
--	FOREIGN KEY(IDFile) REFERENCES AccountFiles(IDFile), 
--	FOREIGN KEY(UserName) REFERENCES Accounts(UserName), 
--	FOREIGN KEY(IDAction) REFERENCES Actions(IDAction)
--);
