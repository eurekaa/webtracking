USE [master]
GO
/****** Object:  Database [webtracking]    Script Date: 11/27/2013 22:52:56 ******/
CREATE DATABASE [webtracking] ON  PRIMARY 
( NAME = N'webtracking', FILENAME = N'D:\databases\sqlserver\webtracking.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'webtracking_log', FILENAME = N'D:\databases\sqlserver\webtracking_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [webtracking] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [webtracking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [webtracking] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [webtracking] SET ANSI_NULLS OFF
GO
ALTER DATABASE [webtracking] SET ANSI_PADDING OFF
GO
ALTER DATABASE [webtracking] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [webtracking] SET ARITHABORT OFF
GO
ALTER DATABASE [webtracking] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [webtracking] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [webtracking] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [webtracking] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [webtracking] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [webtracking] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [webtracking] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [webtracking] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [webtracking] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [webtracking] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [webtracking] SET  DISABLE_BROKER
GO
ALTER DATABASE [webtracking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [webtracking] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [webtracking] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [webtracking] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [webtracking] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [webtracking] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [webtracking] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [webtracking] SET  READ_WRITE
GO
ALTER DATABASE [webtracking] SET RECOVERY FULL
GO
ALTER DATABASE [webtracking] SET  MULTI_USER
GO
ALTER DATABASE [webtracking] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [webtracking] SET DB_CHAINING OFF
GO
USE [webtracking]
GO
/****** Object:  Schema [tracking]    Script Date: 11/27/2013 22:52:56 ******/
CREATE SCHEMA [tracking] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [profiling]    Script Date: 11/27/2013 22:52:56 ******/
CREATE SCHEMA [profiling] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [edijson]    Script Date: 11/27/2013 22:52:56 ******/
CREATE SCHEMA [edijson] AUTHORIZATION [dbo]
GO
/****** Object:  Table [profiling].[profiles]    Script Date: 11/27/2013 22:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [profiling].[profiles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[_deleted] [tinyint] NOT NULL,
 CONSTRAINT [PK_profiles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [tracking].[shipments]    Script Date: 11/27/2013 22:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tracking].[shipments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[shipment_key] [varchar](30) NOT NULL,
	[shipment_date] [date] NOT NULL,
	[shipment_weigth] [numeric](17, 4) NOT NULL,
	[shipment_package] [numeric](7, 0) NOT NULL,
	[shipment_volume] [numeric](9, 2) NOT NULL,
	[courier_code] [char](6) NOT NULL,
	[customer_code] [char](6) NOT NULL,
	[customer_business_name] [varchar](35) NOT NULL,
	[customer_city] [varchar](35) NOT NULL,
	[customer_country] [varchar](6) NOT NULL,
	[sender_code] [char](6) NOT NULL,
	[sender_business_name] [varchar](35) NOT NULL,
	[sender_city] [varchar](35) NOT NULL,
	[sender_country] [varchar](6) NOT NULL,
	[sender_reference] [varchar](30) NOT NULL,
	[consignee_code] [char](6) NOT NULL,
	[consignee_business_name] [varchar](35) NOT NULL,
	[consignee_city] [varchar](35) NOT NULL,
	[consignee_country] [varchar](6) NOT NULL,
	[result_date] [date] NULL,
	[result_type] [varchar](50) NULL,
	[insert_date] [date] NOT NULL,
	[update_date] [date] NULL,
	[_deleted] [tinyint] NOT NULL,
 CONSTRAINT [PK_shipments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [profiling].[users]    Script Date: 11/27/2013 22:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [profiling].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_profile] [int] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[cube_code] [varchar](50) NOT NULL,
	[name] [varchar](200) NULL,
	[surname] [varchar](200) NULL,
	[_deleted] [tinyint] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [edijson].[tracking_shipments]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [edijson].[tracking_shipments] 
@@ACTION varchar(10) = NULL,
@@PHYSICAL tinyint = 0,
@id int = NULL,
@shipment_key varchar(30) = NULL,
@shipment_date date = NULL,
@shipment_weigth numeric = NULL,
@shipment_package numeric = NULL,
@shipment_volume numeric = NULL,
@courier_code char(6) = NULL,
@customer_code char(6) = NULL,
@customer_business_name varchar(35) = NULL,
@customer_city varchar(35) = NULL,
@customer_country varchar(6) = NULL,
@sender_code char(6) = NULL,
@sender_business_name varchar(35) = NULL,
@sender_city varchar(35) = NULL,
@sender_country varchar(6) = NULL,
@sender_reference varchar(30) = NULL,
@consignee_code char(6) = NULL,
@consignee_business_name varchar(35) = NULL,
@consignee_city varchar(35) = NULL,
@consignee_country varchar(6) = NULL,
@result_date date = NULL,
@result_type varchar(50) = NULL,
@insert_date date = NULL,
@update_date date = NULL
AS BEGIN 
SET NOCOUNT ON; 

IF @@ACTION = 'SELECT' BEGIN
SELECT 
id,shipment_key,shipment_date,shipment_weigth,shipment_package,shipment_volume,courier_code,customer_code,customer_business_name,customer_city,customer_country,sender_code,sender_business_name,sender_city,sender_country,sender_reference,consignee_code,consignee_business_name,consignee_city,consignee_country,result_date,result_type,insert_date,update_date
FROM tracking.shipments
 WHERE 1=1 
AND (id = @id OR @id IS NULL) 
AND (shipment_key = @shipment_key OR @shipment_key IS NULL) 
AND (shipment_date = @shipment_date OR @shipment_date IS NULL) 
AND (shipment_weigth = @shipment_weigth OR @shipment_weigth IS NULL) 
AND (shipment_package = @shipment_package OR @shipment_package IS NULL) 
AND (shipment_volume = @shipment_volume OR @shipment_volume IS NULL) 
AND (courier_code = @courier_code OR @courier_code IS NULL) 
AND (customer_code = @customer_code OR @customer_code IS NULL) 
AND (customer_business_name = @customer_business_name OR @customer_business_name IS NULL) 
AND (customer_city = @customer_city OR @customer_city IS NULL) 
AND (customer_country = @customer_country OR @customer_country IS NULL) 
AND (sender_code = @sender_code OR @sender_code IS NULL) 
AND (sender_business_name = @sender_business_name OR @sender_business_name IS NULL) 
AND (sender_city = @sender_city OR @sender_city IS NULL) 
AND (sender_country = @sender_country OR @sender_country IS NULL) 
AND (sender_reference = @sender_reference OR @sender_reference IS NULL) 
AND (consignee_code = @consignee_code OR @consignee_code IS NULL) 
AND (consignee_business_name = @consignee_business_name OR @consignee_business_name IS NULL) 
AND (consignee_city = @consignee_city OR @consignee_city IS NULL) 
AND (consignee_country = @consignee_country OR @consignee_country IS NULL) 
AND (result_date = @result_date OR @result_date IS NULL) 
AND (result_type = @result_type OR @result_type IS NULL) 
AND (insert_date = @insert_date OR @insert_date IS NULL) 
AND (update_date = @update_date OR @update_date IS NULL) 
AND _deleted = 0 
ORDER BY id ASC 
END

ELSE IF @@ACTION = 'INSERT' BEGIN
INSERT INTO [tracking].[shipments] (shipment_key,shipment_date,shipment_weigth,shipment_package,shipment_volume,courier_code,customer_code,customer_business_name,customer_city,customer_country,sender_code,sender_business_name,sender_city,sender_country,sender_reference,consignee_code,consignee_business_name,consignee_city,consignee_country,result_date,result_type,insert_date,update_date) 
OUTPUT INSERTED.id
VALUES (@shipment_key,@shipment_date,@shipment_weigth,@shipment_package,@shipment_volume,@courier_code,@customer_code,@customer_business_name,@customer_city,@customer_country,@sender_code,@sender_business_name,@sender_city,@sender_country,@sender_reference,@consignee_code,@consignee_business_name,@consignee_city,@consignee_country,@result_date,@result_type,@insert_date,@update_date)
END

ELSE IF @@ACTION = 'UPDATE' BEGIN
UPDATE [tracking].[shipments] SET 
shipment_key = @shipment_key,
shipment_date = @shipment_date,
shipment_weigth = @shipment_weigth,
shipment_package = @shipment_package,
shipment_volume = @shipment_volume,
courier_code = @courier_code,
customer_code = @customer_code,
customer_business_name = @customer_business_name,
customer_city = @customer_city,
customer_country = @customer_country,
sender_code = @sender_code,
sender_business_name = @sender_business_name,
sender_city = @sender_city,
sender_country = @sender_country,
sender_reference = @sender_reference,
consignee_code = @consignee_code,
consignee_business_name = @consignee_business_name,
consignee_city = @consignee_city,
consignee_country = @consignee_country,
result_date = @result_date,
result_type = @result_type,
insert_date = @insert_date,
update_date = @update_date
OUTPUT INSERTED.id
WHERE tracking.shipments.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 0 BEGIN
UPDATE [tracking].[shipments] SET _deleted = 1 
OUTPUT INSERTED.id
WHERE tracking.shipments.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 1 BEGIN
DELETE FROM [tracking].[shipments] 
OUTPUT DELETED.id
WHERE tracking.shipments.id= @id
END 

END
GO
/****** Object:  StoredProcedure [tracking].[shipments_search]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tracking].[shipments_search] 
@shipment_date_from date = '1900-01-01',
@shipment_date_to date = '2999-01-01',
@courier_code char(6) = NULL,
@sender_code char(6) = NULL,
@sender_business_name varchar(35) = NULL,
@sender_reference varchar(30) = NULL,
@consignee_code char(6) = NULL,
@consignee_business_name varchar(35) = NULL
AS BEGIN 
SET NOCOUNT ON; 
 
SELECT * FROM tracking.shipments WHERE 1=1 
AND (shipment_date BETWEEN @shipment_date_from AND @shipment_date_to OR (@shipment_date_from IS NULL AND @shipment_date_to IS NULL)) 
AND (courier_code = @courier_code OR @courier_code IS NULL) 
AND (sender_code = @sender_code OR @sender_code IS NULL) 
AND (sender_business_name LIKE '%' +@sender_business_name + '%' OR @sender_business_name IS NULL) 
AND (sender_reference LIKE '%' + @sender_reference + '%' OR @sender_reference IS NULL) 
AND (consignee_code = @consignee_code OR @consignee_code IS NULL) 
AND (consignee_business_name LIKE '%' + @consignee_business_name + '%' OR @consignee_business_name IS NULL) 
AND _deleted = 0 
ORDER BY id ASC

END
GO
/****** Object:  StoredProcedure [edijson].[profiling_profiles]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [edijson].[profiling_profiles] 
@@ACTION varchar(10) = NULL,
@@PHYSICAL tinyint = 0,
@id int = NULL,
@name varchar(50) = NULL
AS BEGIN 
SET NOCOUNT ON; 

IF @@ACTION = 'SELECT' BEGIN
SELECT 
id,name
FROM profiling.profiles
 WHERE 1=1 
AND (id = @id OR @id IS NULL) 
AND (name = @name OR @name IS NULL) 
AND _deleted = 0 
ORDER BY id ASC 
END

ELSE IF @@ACTION = 'INSERT' BEGIN
INSERT INTO [profiling].[profiles] (name) 
OUTPUT INSERTED.id
VALUES (@name)
END

ELSE IF @@ACTION = 'UPDATE' BEGIN
UPDATE [profiling].[profiles] SET 
name = @name
OUTPUT INSERTED.id
WHERE profiling.profiles.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 0 BEGIN
UPDATE [profiling].[profiles] SET _deleted = 1 
OUTPUT INSERTED.id
WHERE profiling.profiles.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 1 BEGIN
DELETE FROM [profiling].[profiles] 
OUTPUT DELETED.id
WHERE profiling.profiles.id= @id
END 

END
GO
/****** Object:  StoredProcedure [edijson].[profiling_users]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [edijson].[profiling_users] 
@@ACTION varchar(10) = NULL,
@@PHYSICAL tinyint = 0,
@id int = NULL,
@id_profile int = NULL,
@username varchar(50) = NULL,
@password varchar(50) = NULL,
@email varchar(150) = NULL,
@cube_code varchar(50) = NULL,
@name varchar(200) = NULL,
@surname varchar(200) = NULL
AS BEGIN 
SET NOCOUNT ON; 

IF @@ACTION = 'SELECT' BEGIN
SELECT 
id,id_profile,username,password,email,cube_code,name,surname
FROM profiling.users
 WHERE 1=1 
AND (id = @id OR @id IS NULL) 
AND (id_profile = @id_profile OR @id_profile IS NULL) 
AND (username = @username OR @username IS NULL) 
AND (password = @password OR @password IS NULL) 
AND (email = @email OR @email IS NULL) 
AND (cube_code = @cube_code OR @cube_code IS NULL) 
AND (name = @name OR @name IS NULL) 
AND (surname = @surname OR @surname IS NULL) 
AND _deleted = 0 
ORDER BY id ASC 
END

ELSE IF @@ACTION = 'INSERT' BEGIN
INSERT INTO [profiling].[users] (id_profile,username,password,email,cube_code,name,surname) 
OUTPUT INSERTED.id
VALUES (@id_profile,@username,@password,@email,@cube_code,@name,@surname)
END

ELSE IF @@ACTION = 'UPDATE' BEGIN
UPDATE [profiling].[users] SET 
id_profile = @id_profile,
username = @username,
password = @password,
email = @email,
cube_code = @cube_code,
name = @name,
surname = @surname
OUTPUT INSERTED.id
WHERE profiling.users.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 0 BEGIN
UPDATE [profiling].[users] SET _deleted = 1 
OUTPUT INSERTED.id
WHERE profiling.users.id = @id
END 

ELSE IF @@ACTION = 'DELETE' AND @@PHYSICAL = 1 BEGIN
DELETE FROM [profiling].[users] 
OUTPUT DELETED.id
WHERE profiling.users.id= @id
END 

END
GO
/****** Object:  View [profiling].[accounts]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [profiling].[accounts]
AS
SELECT     profiling.profiles.name AS profile, profiling.users.id, profiling.users.id_profile, profiling.users.username, profiling.users.password, profiling.users.email, 
                      profiling.users.name, profiling.users.surname, profiling.users.cube_code
FROM         profiling.profiles INNER JOIN
                      profiling.users ON profiling.profiles.id = profiling.users.id_profile
WHERE     (profiling.users._deleted = 0) AND (profiling.profiles._deleted = 0)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[58] 4[3] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "profiles (profiling)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "users (profiling)"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 227
               Right = 500
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'profiling', @level1type=N'VIEW',@level1name=N'accounts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'profiling', @level1type=N'VIEW',@level1name=N'accounts'
GO
/****** Object:  StoredProcedure [edijson].[profiling_accounts]    Script Date: 11/27/2013 22:52:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [edijson].[profiling_accounts] 
@@ACTION varchar(10) = NULL,
@profile varchar(50) = NULL,
@id int = NULL,
@id_profile int = NULL,
@username varchar(50) = NULL,
@password varchar(50) = NULL,
@email varchar(150) = NULL,
@name varchar(200) = NULL,
@surname varchar(200) = NULL,
@cube_code varchar(50) = NULL
AS BEGIN 
SET NOCOUNT ON; 

IF @@ACTION = 'SELECT' BEGIN
SELECT 
profile,id,id_profile,username,password,email,name,surname,cube_code
FROM profiling.accounts
 WHERE 1=1 
AND (profile = @profile OR @profile IS NULL) 
AND (id = @id OR @id IS NULL) 
AND (id_profile = @id_profile OR @id_profile IS NULL) 
AND (username = @username OR @username IS NULL) 
AND (password = @password OR @password IS NULL) 
AND (email = @email OR @email IS NULL) 
AND (name = @name OR @name IS NULL) 
AND (surname = @surname OR @surname IS NULL) 
AND (cube_code = @cube_code OR @cube_code IS NULL) 
ORDER BY id ASC 
END

END
GO
/****** Object:  Default [DF_profiles__deleted]    Script Date: 11/27/2013 22:52:57 ******/
ALTER TABLE [profiling].[profiles] ADD  CONSTRAINT [DF_profiles__deleted]  DEFAULT ((0)) FOR [_deleted]
GO
/****** Object:  Default [DF_shipments_insertdate]    Script Date: 11/27/2013 22:52:57 ******/
ALTER TABLE [tracking].[shipments] ADD  CONSTRAINT [DF_shipments_insertdate]  DEFAULT (getdate()) FOR [insert_date]
GO
/****** Object:  Default [DF_shipments__deleted]    Script Date: 11/27/2013 22:52:57 ******/
ALTER TABLE [tracking].[shipments] ADD  CONSTRAINT [DF_shipments__deleted]  DEFAULT ((0)) FOR [_deleted]
GO
/****** Object:  Default [DF_users__deleted]    Script Date: 11/27/2013 22:52:57 ******/
ALTER TABLE [profiling].[users] ADD  CONSTRAINT [DF_users__deleted]  DEFAULT ((0)) FOR [_deleted]
GO
/****** Object:  ForeignKey [FK_users_profiles]    Script Date: 11/27/2013 22:52:57 ******/
ALTER TABLE [profiling].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_profiles] FOREIGN KEY([id_profile])
REFERENCES [profiling].[profiles] ([id])
GO
ALTER TABLE [profiling].[users] CHECK CONSTRAINT [FK_users_profiles]
GO
