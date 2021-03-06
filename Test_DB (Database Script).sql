USE [master]
GO
/****** Object:  Database [Test_DB]    Script Date: 28-11-2019 20:11:09 ******/
CREATE DATABASE [Test_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Test_DB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Test_DB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Test_DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Test_DB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Test_DB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Test_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Test_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Test_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Test_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Test_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Test_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [Test_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Test_DB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Test_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Test_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Test_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Test_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Test_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Test_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Test_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Test_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Test_DB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Test_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Test_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Test_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Test_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Test_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Test_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Test_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Test_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [Test_DB] SET  MULTI_USER 
GO
ALTER DATABASE [Test_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Test_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Test_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Test_DB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Test_DB]
GO
/****** Object:  StoredProcedure [dbo].[Get_Employee]    Script Date: 28-11-2019 20:11:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Get_Employee] ( @p_ID INT )
AS
    BEGIN
		
       SELECT ID,
			  ISNULL(Name, '') AS Name,
			  ISNULL(Age, 0) AS Age,
			  ISNULL(Marital_Status, '') AS Marital_Status,
			  ISNULL(Salary, 0) AS Salary,
			  ISNULL(Location, '') AS Location

	   FROM Employees
	   WHERE 1 = (CASE WHEN  ISNULL(@p_ID, 0) = 0 THEN 1
					   WHEN  ID = ISNULL(@p_ID, 0) THEN 1
				  ELSE 0
				  END )
	   ORDER BY ID
    END        


  

GO
/****** Object:  StoredProcedure [dbo].[Save_Employee]    Script Date: 28-11-2019 20:11:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Save_Employee] 
( 
	@p_Flag CHAR(1),
	@p_ID  INT,
	@p_Name VARCHAR(240),
	@p_Age INT,
	@p_Marital_Status VARCHAR(100),
	@p_Salary DECIMAL,
	@p_Location VARCHAR(240)
)
AS
    BEGIN
		DECLARE @v_ID INT
		SET @v_ID = @p_ID
		 BEGIN TRY
            
			BEGIN TRANSACTION  

			IF @p_Flag = 'I'
            BEGIN 
				
				INSERT INTO Employees 
									( Name ,
									  Age ,
									  Salary,
									  Location,
									  Marital_Status
									)
									VALUES(  @p_Name ,
											 @p_Age ,
											 @p_Salary ,
											 @p_Location,
											 @p_Marital_Status 
										  )
                
				SET @v_ID = @@IDENTITY
            END
			ELSE
				IF @p_Flag = 'E'
				BEGIN 

					UPDATE Employees SET Name = @p_Name,
										 Age = @p_Age,
										 Salary = @p_Salary,
										 Location = @p_Location,
										 Marital_Status = @p_Marital_Status
					WHERE ID = @p_ID

				END
				ELSE
					IF @p_Flag = 'D'
						BEGIN 

							DELETE Employees WHERE ID = @p_ID

						END

			COMMIT TRANSACTION  
			SELECT @v_ID
        END TRY 
        BEGIN CATCH
            ROLLBACK TRANSACTION  
            SELECT -1
        END CATCH
    END        


  

GO
/****** Object:  Table [dbo].[Employees]    Script Date: 28-11-2019 20:11:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Employees](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](240) NULL,
	[Age] [int] NULL,
	[Salary] [decimal](18, 0) NULL,
	[Location] [varchar](240) NULL,
	[Marital_Status] [varchar](100) NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([ID], [Name], [Age], [Salary], [Location], [Marital_Status]) VALUES (1, N'ABC', 30, CAST(30000 AS Decimal(18, 0)), N'Pune', N'Married')
INSERT [dbo].[Employees] ([ID], [Name], [Age], [Salary], [Location], [Marital_Status]) VALUES (2, N'XYZ', 28, CAST(25000 AS Decimal(18, 0)), N'Pune', N'Married')
INSERT [dbo].[Employees] ([ID], [Name], [Age], [Salary], [Location], [Marital_Status]) VALUES (3, N'ABC', 30, CAST(30000 AS Decimal(18, 0)), N'Pune', N'Married')
INSERT [dbo].[Employees] ([ID], [Name], [Age], [Salary], [Location], [Marital_Status]) VALUES (6, N'B1', 24, CAST(20000 AS Decimal(18, 0)), N'Pune', N'Married')
SET IDENTITY_INSERT [dbo].[Employees] OFF
USE [master]
GO
ALTER DATABASE [Test_DB] SET  READ_WRITE 
GO
