
USE [master]
GO

/****** Object:  Database [ContosoRetailDW]    Script Date: 14/05/2018 09:21:40 ******/
CREATE DATABASE [ContosoRetailDW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ContosoRetailDW2.0', FILENAME = N'M:\MSSQL\ContosoRetail\ContosoRetailDW.mdf' , SIZE = 1270784KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ContosoRetailDW2.0_log', FILENAME = N'M:\MSSQL\ContosoRetail\ContosoRetailDW.ldf' , SIZE = 137720KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [ContosoRetailDW] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ContosoRetailDW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [ContosoRetailDW] SET ANSI_NULL_DEFAULT ON
GO

ALTER DATABASE [ContosoRetailDW] SET ANSI_NULLS ON
GO

ALTER DATABASE [ContosoRetailDW] SET ANSI_PADDING ON
GO

ALTER DATABASE [ContosoRetailDW] SET ANSI_WARNINGS ON
GO

ALTER DATABASE [ContosoRetailDW] SET ARITHABORT ON
GO

ALTER DATABASE [ContosoRetailDW] SET AUTO_CLOSE OFF
GO

ALTER DATABASE [ContosoRetailDW] SET AUTO_SHRINK OFF
GO

ALTER DATABASE [ContosoRetailDW] SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [ContosoRetailDW] SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [ContosoRetailDW] SET CURSOR_DEFAULT  LOCAL
GO

ALTER DATABASE [ContosoRetailDW] SET CONCAT_NULL_YIELDS_NULL ON
GO

ALTER DATABASE [ContosoRetailDW] SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [ContosoRetailDW] SET QUOTED_IDENTIFIER ON
GO

ALTER DATABASE [ContosoRetailDW] SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [ContosoRetailDW] SET  DISABLE_BROKER
GO

ALTER DATABASE [ContosoRetailDW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [ContosoRetailDW] SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [ContosoRetailDW] SET TRUSTWORTHY OFF
GO

ALTER DATABASE [ContosoRetailDW] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [ContosoRetailDW] SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [ContosoRetailDW] SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [ContosoRetailDW] SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [ContosoRetailDW] SET RECOVERY FULL
GO

ALTER DATABASE [ContosoRetailDW] SET  MULTI_USER
GO

ALTER DATABASE [ContosoRetailDW] SET PAGE_VERIFY NONE
GO

ALTER DATABASE [ContosoRetailDW] SET DB_CHAINING OFF
GO

ALTER DATABASE [ContosoRetailDW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO

ALTER DATABASE [ContosoRetailDW] SET TARGET_RECOVERY_TIME = 0 SECONDS
GO

ALTER DATABASE [ContosoRetailDW] SET DELAYED_DURABILITY = DISABLED
GO

EXEC sys.sp_db_vardecimal_storage_format N'ContosoRetailDW', N'ON'
GO

ALTER DATABASE [ContosoRetailDW] SET QUERY_STORE = OFF
GO

USE [ContosoRetailDW]
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

USE [ContosoRetailDW]
GO

/****** Object:  Table [dbo].[DimProductSubcategory]    Script Date: 14/05/2018 09:21:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimProduct]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimProductCategory]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimDate]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactOnlineSales]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_ProductForecast]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimCustomer]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimGeography]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_CustomerOrders]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_OnlineSalesOrderDetail]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_Customer]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimPromotion]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_CustomerPromotion]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[V_OnlineSalesOrder]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [audit].[DimChannel]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimAccount]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimChannel]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimCurrency]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimEmployee]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimEntity]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimMachine]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimOutage]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimSalesTerritory]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimScenario]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[DimStore]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactExchangeRate]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactInventory]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactITMachine]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactITSLA]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactSales]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactSalesQuota]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[FactStrategyPlan]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[P_FactSalesQuota]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[P_FactStrategyPlan]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[Populate_dbo_DimProduct]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[Populate_DimChannel]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Trigger [dbo].[Trigger_DimChannel]    Script Date: 14/05/2018 09:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [master]
GO

ALTER DATABASE [ContosoRetailDW] SET  READ_WRITE
GO
