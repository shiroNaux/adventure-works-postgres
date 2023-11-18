-- ******************************************************
-- Create User Defined Functions
-- ******************************************************
-- Builds an ISO 8601 format date from a year, month, and day specified as integers.
-- This format of date should parse correctly regardless of SET DATEFORMAT and SET LANGUAGE.
-- See SQL Server Books Online for more details.
CREATE FUNCTION "dbo"."udfBuildISO8601Date" (@year int, @month int, @day int)
RETURNS datetime
AS 
BEGIN
	RETURN cast(convert(varchar, @year) + '-' + "dbo"."udfTwoDigitZeroFill"(@month) 
	    + '-' + "dbo"."udfTwoDigitZeroFill"(@day) + 'T00:00:00' 
	    as datetime);
END;
GO
/****** Object:  UserDefinedFunction "dbo"."udfMinimumDate"    Script Date: 25/09/2023 11:15:58 ******/


CREATE FUNCTION "dbo"."udfMinimumDate" (
    @x DATETIME, 
    @y DATETIME
) RETURNS DATETIME
AS
BEGIN
    DECLARE @z DATETIME

    IF @x <= @y 
        SET @z = @x 
    ELSE 
        SET @z = @y

    RETURN(@z)
END;
GO
/****** Object:  UserDefinedFunction "dbo"."udfTwoDigitZeroFill"    Script Date: 25/09/2023 11:15:58 ******/

-- Converts the specified integer (which should be < 100 and > -1)
-- into a two character string, zero filling from the left 
-- if the number is < 10.
CREATE FUNCTION "dbo"."udfTwoDigitZeroFill" (@number int) 
RETURNS char(2)
AS
BEGIN
	DECLARE @result char(2);
	IF @number > 9 
		SET @result = convert(char(2), @number);
	ELSE
		SET @result = convert(char(2), '0' + convert(varchar, @number));
	RETURN @result;
END;
GO


CREATE TABLE "dbo"."DimCustomer"(
	"CustomerKey" "int" IDENTITY(1,1) NOT NULL,
	"GeographyKey" "int" NULL,
	"CustomerAlternateKey" varchar(15) NOT NULL,
	"Title" varchar(8) NULL,
	"FirstName" varchar(50) NULL,
	"MiddleName" varchar(50) NULL,
	"LastName" varchar(50) NULL,
	"NameStyle" "bit" NULL,
	"BirthDate" "date" NULL,
	"MaritalStatus" "nchar"(1) NULL,
	"Suffix" varchar(10) NULL,
	"Gender" varchar(1) NULL,
	"EmailAddress" varchar(50) NULL,
	"YearlyIncome" "money" NULL,
	"TotalChildren" "tinyint" NULL,
	"NumberChildrenAtHome" "tinyint" NULL,
	"EnglishEducation" varchar(40) NULL,
	"SpanishEducation" varchar(40) NULL,
	"FrenchEducation" varchar(40) NULL,
	"EnglishOccupation" varchar(100) NULL,
	"SpanishOccupation" varchar(100) NULL,
	"FrenchOccupation" varchar(100) NULL,
	"HouseOwnerFlag" "nchar"(1) NULL,
	"NumberCarsOwned" "tinyint" NULL,
	"AddressLine1" varchar(120) NULL,
	"AddressLine2" varchar(120) NULL,
	"Phone" varchar(20) NULL,
	"DateFirstPurchase" "date" NULL,
	"CommuteDistance" varchar(15) NULL,
 CONSTRAINT "PK_DimCustomer_CustomerKey" PRIMARY KEY CLUSTERED 
(
	"CustomerKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimDate"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimDate"(
	"DateKey" "int" NOT NULL,
	"FullDateAlternateKey" "date" NOT NULL,
	"DayNumberOfWeek" "tinyint" NOT NULL,
	"EnglishDayNameOfWeek" varchar(10) NOT NULL,
	"SpanishDayNameOfWeek" varchar(10) NOT NULL,
	"FrenchDayNameOfWeek" varchar(10) NOT NULL,
	"DayNumberOfMonth" "tinyint" NOT NULL,
	"DayNumberOfYear" "smallint" NOT NULL,
	"WeekNumberOfYear" "tinyint" NOT NULL,
	"EnglishMonthName" varchar(10) NOT NULL,
	"SpanishMonthName" varchar(10) NOT NULL,
	"FrenchMonthName" varchar(10) NOT NULL,
	"MonthNumberOfYear" "tinyint" NOT NULL,
	"CalendarQuarter" "tinyint" NOT NULL,
	"CalendarYear" "smallint" NOT NULL,
	"CalendarSemester" "tinyint" NOT NULL,
	"FiscalQuarter" "tinyint" NOT NULL,
	"FiscalYear" "smallint" NOT NULL,
	"FiscalSemester" "tinyint" NOT NULL,
 CONSTRAINT "PK_DimDate_DateKey" PRIMARY KEY CLUSTERED 
(
	"DateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimGeography"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimGeography"(
	"GeographyKey" "int" IDENTITY(1,1) NOT NULL,
	"City" varchar(30) NULL,
	"StateProvinceCode" varchar(3) NULL,
	"StateProvinceName" varchar(50) NULL,
	"CountryRegionCode" varchar(3) NULL,
	"EnglishCountryRegionName" varchar(50) NULL,
	"SpanishCountryRegionName" varchar(50) NULL,
	"FrenchCountryRegionName" varchar(50) NULL,
	"PostalCode" varchar(15) NULL,
	"SalesTerritoryKey" "int" NULL,
	"IpAddressLocator" varchar(15) NULL,
 CONSTRAINT "PK_DimGeography_GeographyKey" PRIMARY KEY CLUSTERED 
(
	"GeographyKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimProduct"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimProduct"(
	"ProductKey" "int" IDENTITY(1,1) NOT NULL,
	"ProductAlternateKey" varchar(25) NULL,
	"ProductSubcategoryKey" "int" NULL,
	"WeightUnitMeasureCode" "nchar"(3) NULL,
	"SizeUnitMeasureCode" "nchar"(3) NULL,
	"EnglishProductName" varchar(50) NOT NULL,
	"SpanishProductName" varchar(50) NOT NULL,
	"FrenchProductName" varchar(50) NOT NULL,
	"StandardCost" "money" NULL,
	"FinishedGoodsFlag" "bit" NOT NULL,
	"Color" varchar(15) NOT NULL,
	"SafetyStockLevel" "smallint" NULL,
	"ReorderPoint" "smallint" NULL,
	"ListPrice" "money" NULL,
	"Size" varchar(50) NULL,
	"SizeRange" varchar(50) NULL,
	"Weight" "float" NULL,
	"DaysToManufacture" "int" NULL,
	"ProductLine" "nchar"(2) NULL,
	"DealerPrice" "money" NULL,
	"Class" "nchar"(2) NULL,
	"Style" "nchar"(2) NULL,
	"ModelName" varchar(50) NULL,
	"LargePhoto" "varbinary"(max) NULL,
	"EnglishDescription" varchar(400) NULL,
	"FrenchDescription" varchar(400) NULL,
	"ChineseDescription" varchar(400) NULL,
	"ArabicDescription" varchar(400) NULL,
	"HebrewDescription" varchar(400) NULL,
	"ThaiDescription" varchar(400) NULL,
	"GermanDescription" varchar(400) NULL,
	"JapaneseDescription" varchar(400) NULL,
	"TurkishDescription" varchar(400) NULL,
	"StartDate" "datetime" NULL,
	"EndDate" "datetime" NULL,
	"Status" varchar(7) NULL,
 CONSTRAINT "PK_DimProduct_ProductKey" PRIMARY KEY CLUSTERED 
(
	"ProductKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimProduct_ProductAlternateKey_StartDate" UNIQUE NONCLUSTERED 
(
	"ProductAlternateKey" ASC,
	"StartDate" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY" TEXTIMAGE_ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimProductCategory"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimProductCategory"(
	"ProductCategoryKey" "int" IDENTITY(1,1) NOT NULL,
	"ProductCategoryAlternateKey" "int" NULL,
	"EnglishProductCategoryName" varchar(50) NOT NULL,
	"SpanishProductCategoryName" varchar(50) NOT NULL,
	"FrenchProductCategoryName" varchar(50) NOT NULL,
 CONSTRAINT "PK_DimProductCategory_ProductCategoryKey" PRIMARY KEY CLUSTERED 
(
	"ProductCategoryKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimProductCategory_ProductCategoryAlternateKey" UNIQUE NONCLUSTERED 
(
	"ProductCategoryAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimProductSubcategory"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimProductSubcategory"(
	"ProductSubcategoryKey" "int" IDENTITY(1,1) NOT NULL,
	"ProductSubcategoryAlternateKey" "int" NULL,
	"EnglishProductSubcategoryName" varchar(50) NOT NULL,
	"SpanishProductSubcategoryName" varchar(50) NOT NULL,
	"FrenchProductSubcategoryName" varchar(50) NOT NULL,
	"ProductCategoryKey" "int" NULL,
 CONSTRAINT "PK_DimProductSubcategory_ProductSubcategoryKey" PRIMARY KEY CLUSTERED 
(
	"ProductSubcategoryKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimProductSubcategory_ProductSubcategoryAlternateKey" UNIQUE NONCLUSTERED 
(
	"ProductSubcategoryAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimSalesTerritory"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimSalesTerritory"(
	"SalesTerritoryKey" "int" IDENTITY(1,1) NOT NULL,
	"SalesTerritoryAlternateKey" "int" NULL,
	"SalesTerritoryRegion" varchar(50) NOT NULL,
	"SalesTerritoryCountry" varchar(50) NOT NULL,
	"SalesTerritoryGroup" varchar(50) NULL,
	"SalesTerritoryImage" "varbinary"(max) NULL,
 CONSTRAINT "PK_DimSalesTerritory_SalesTerritoryKey" PRIMARY KEY CLUSTERED 
(
	"SalesTerritoryKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimSalesTerritory_SalesTerritoryAlternateKey" UNIQUE NONCLUSTERED 
(
	"SalesTerritoryAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY" TEXTIMAGE_ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactInternetSales"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactInternetSales"(
	"ProductKey" "int" NOT NULL,
	"OrderDateKey" "int" NOT NULL,
	"DueDateKey" "int" NOT NULL,
	"ShipDateKey" "int" NOT NULL,
	"CustomerKey" "int" NOT NULL,
	"PromotionKey" "int" NOT NULL,
	"CurrencyKey" "int" NOT NULL,
	"SalesTerritoryKey" "int" NOT NULL,
	"SalesOrderNumber" varchar(20) NOT NULL,
	"SalesOrderLineNumber" "tinyint" NOT NULL,
	"RevisionNumber" "tinyint" NOT NULL,
	"OrderQuantity" "smallint" NOT NULL,
	"UnitPrice" "money" NOT NULL,
	"ExtendedAmount" "money" NOT NULL,
	"UnitPriceDiscountPct" "float" NOT NULL,
	"DiscountAmount" "float" NOT NULL,
	"ProductStandardCost" "money" NOT NULL,
	"TotalProductCost" "money" NOT NULL,
	"SalesAmount" "money" NOT NULL,
	"TaxAmt" "money" NOT NULL,
	"Freight" "money" NOT NULL,
	"CarrierTrackingNumber" varchar(25) NULL,
	"CustomerPONumber" varchar(25) NULL,
	"OrderDate" "datetime" NULL,
	"DueDate" "datetime" NULL,
	"ShipDate" "datetime" NULL,
 CONSTRAINT "PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber" PRIMARY KEY CLUSTERED 
(
	"SalesOrderNumber" ASC,
	"SalesOrderLineNumber" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  View "dbo"."vDMPrep"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- vDMPrep will be used as a data source by the other data mining views.  
-- Uses DW data at customer, product, day, etc. granularity and
-- gets region, model, year, month, etc.
CREATE VIEW "dbo"."vDMPrep"
AS
    SELECT
        pc."EnglishProductCategoryName"
        ,Coalesce(p."ModelName", p."EnglishProductName") AS "Model"
        ,c."CustomerKey"
        ,s."SalesTerritoryGroup" AS "Region"
        ,CASE
            WHEN Month(GetDate()) < Month(c."BirthDate")
                THEN DateDiff(yy,c."BirthDate",GetDate()) - 1
            WHEN Month(GetDate()) = Month(c."BirthDate")
            AND Day(GetDate()) < Day(c."BirthDate")
                THEN DateDiff(yy,c."BirthDate",GetDate()) - 1
            ELSE DateDiff(yy,c."BirthDate",GetDate())
        END AS "Age"
        ,CASE
            WHEN c."YearlyIncome" < 40000 THEN 'Low'
            WHEN c."YearlyIncome" > 60000 THEN 'High'
            ELSE 'Moderate'
        END AS "IncomeGroup"
        ,d."CalendarYear"
        ,d."FiscalYear"
        ,d."MonthNumberOfYear" AS "Month"
        ,f."SalesOrderNumber" AS "OrderNumber"
        ,f.SalesOrderLineNumber AS LineNumber
        ,f.OrderQuantity AS Quantity
        ,f.ExtendedAmount AS Amount  
    FROM
        "dbo"."FactInternetSales" f
    INNER JOIN "dbo"."DimDate" d
        ON f."OrderDateKey" = d."DateKey"
    INNER JOIN "dbo"."DimProduct" p
        ON f."ProductKey" = p."ProductKey"
    INNER JOIN "dbo"."DimProductSubcategory" psc
        ON p."ProductSubcategoryKey" = psc."ProductSubcategoryKey"
    INNER JOIN "dbo"."DimProductCategory" pc
        ON psc."ProductCategoryKey" = pc."ProductCategoryKey"
    INNER JOIN "dbo"."DimCustomer" c
        ON f."CustomerKey" = c."CustomerKey"
    INNER JOIN "dbo"."DimGeography" g
        ON c."GeographyKey" = g."GeographyKey"
    INNER JOIN "dbo"."DimSalesTerritory" s
        ON g."SalesTerritoryKey" = s."SalesTerritoryKey" 
;

GO
/****** Object:  View "dbo"."vTimeSeries"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- vTimeSeries view supports the creation of time series data mining models.
--      - Replaces earlier bike models with successor models.
--      - Abbreviates model names to improve readability in mining model viewer
--      - Concatenates model and region so that table only has one input.
--      - Creates a date field indexed to monthly reporting date for use in prediction.
CREATE VIEW "dbo"."vTimeSeries" 
AS
    SELECT 
        CASE "Model" 
            WHEN 'Mountain-100' THEN 'M200' 
            WHEN 'Road-150' THEN 'R250' 
            WHEN 'Road-650' THEN 'R750' 
            WHEN 'Touring-1000' THEN 'T1000' 
            ELSE Left("Model", 1) + Right("Model", 3) 
        END + ' ' + "Region" AS "ModelRegion" 
        ,(Convert(Integer, "CalendarYear") * 100) + Convert(Integer, "Month") AS "TimeIndex" 
        ,Sum("Quantity") AS "Quantity" 
        ,Sum("Amount") AS "Amount"
		,CalendarYear
		,"Month"
		,"dbo"."udfBuildISO8601Date" ("CalendarYear", "Month", 25)
		as ReportingDate
    FROM 
        "dbo"."vDMPrep" 
    WHERE 
        "Model" IN ('Mountain-100', 'Mountain-200', 'Road-150', 'Road-250', 
            'Road-650', 'Road-750', 'Touring-1000') 
    GROUP BY 
        CASE "Model" 
            WHEN 'Mountain-100' THEN 'M200' 
            WHEN 'Road-150' THEN 'R250' 
            WHEN 'Road-650' THEN 'R750' 
            WHEN 'Touring-1000' THEN 'T1000' 
            ELSE Left(Model,1) + Right(Model,3) 
        END + ' ' + "Region" 
        ,(Convert(Integer, "CalendarYear") * 100) + Convert(Integer, "Month")
		,CalendarYear
		,"Month"
		,"dbo"."udfBuildISO8601Date" ("CalendarYear", "Month", 25);

GO
/****** Object:  View "dbo"."vTargetMail"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- vTargetMail supports targeted mailing data model
-- Uses vDMPrep to determine if a customer buys a bike and joins to DimCustomer
CREATE VIEW "dbo"."vTargetMail" 
AS
    SELECT
        c."CustomerKey", 
        c."GeographyKey", 
        c."CustomerAlternateKey", 
        c."Title", 
        c."FirstName", 
        c."MiddleName", 
        c."LastName", 
        c."NameStyle", 
        c."BirthDate", 
        c."MaritalStatus", 
        c."Suffix", 
        c."Gender", 
        c."EmailAddress", 
        c."YearlyIncome", 
        c."TotalChildren", 
        c."NumberChildrenAtHome", 
        c."EnglishEducation", 
        c."SpanishEducation", 
        c."FrenchEducation", 
        c."EnglishOccupation", 
        c."SpanishOccupation", 
        c."FrenchOccupation", 
        c."HouseOwnerFlag", 
        c."NumberCarsOwned", 
        c."AddressLine1", 
        c."AddressLine2", 
        c."Phone", 
        c."DateFirstPurchase", 
        c."CommuteDistance", 
        x."Region", 
        x."Age", 
        CASE x."Bikes" 
            WHEN 0 THEN 0 
            ELSE 1 
        END AS "BikeBuyer"
    FROM
        "dbo"."DimCustomer" c INNER JOIN (
            SELECT
                "CustomerKey"
                ,"Region"
                ,"Age"
                ,Sum(
                    CASE "EnglishProductCategoryName" 
                        WHEN 'Bikes' THEN 1 
                        ELSE 0 
                    END) AS "Bikes"
            FROM
                "dbo"."vDMPrep" 
            GROUP BY
                "CustomerKey"
                ,"Region"
                ,"Age"
            ) AS "x"
        ON c."CustomerKey" = x."CustomerKey"
;

GO
/****** Object:  View "dbo"."vAssocSeqOrders"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* vAssocSeqOrders supports assocation and sequence clustering data mmining models.
      - Limits data to FY2004.
      - Creates order case table and line item nested table.*/
CREATE VIEW "dbo"."vAssocSeqOrders"
AS
SELECT DISTINCT OrderNumber, CustomerKey, Region, IncomeGroup
FROM         dbo.vDMPrep
WHERE     (FiscalYear = '2013')

GO
/****** Object:  View "dbo"."vAssocSeqLineItems"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW "dbo"."vAssocSeqLineItems"
AS
SELECT     OrderNumber, LineNumber, Model
FROM         dbo.vDMPrep
WHERE     (FiscalYear = '2013')
GO
/****** Object:  Table "dbo"."AdventureWorksDWBuildVersion"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."AdventureWorksDWBuildVersion"(
	"DBVersion" varchar(50) NULL,
	"VersionDate" "datetime" NULL
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DatabaseLog"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DatabaseLog"(
	"DatabaseLogID" "int" IDENTITY(1,1) NOT NULL,
	"PostTime" "datetime" NOT NULL,
	"DatabaseUser" "sysname" NOT NULL,
	"Event" "sysname" NOT NULL,
	"Schema" "sysname" NULL,
	"Object" "sysname" NULL,
	"TSQL" varchar(max) NOT NULL,
	"XmlEvent" "xml" NOT NULL,
 CONSTRAINT "PK_DatabaseLog_DatabaseLogID" PRIMARY KEY NONCLUSTERED 
(
	"DatabaseLogID" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY" TEXTIMAGE_ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimAccount"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimAccount"(
	"AccountKey" "int" IDENTITY(1,1) NOT NULL,
	"ParentAccountKey" "int" NULL,
	"AccountCodeAlternateKey" "int" NULL,
	"ParentAccountCodeAlternateKey" "int" NULL,
	"AccountDescription" varchar(50) NULL,
	"AccountType" varchar(50) NULL,
	"Operator" varchar(50) NULL,
	"CustomMembers" varchar(300) NULL,
	"ValueType" varchar(50) NULL,
	"CustomMemberOptions" varchar(200) NULL,
 CONSTRAINT "PK_DimAccount" PRIMARY KEY CLUSTERED 
(
	"AccountKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimCurrency"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimCurrency"(
	"CurrencyKey" "int" IDENTITY(1,1) NOT NULL,
	"CurrencyAlternateKey" "nchar"(3) NOT NULL,
	"CurrencyName" varchar(50) NOT NULL,
 CONSTRAINT "PK_DimCurrency_CurrencyKey" PRIMARY KEY CLUSTERED 
(
	"CurrencyKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimDepartmentGroup"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimDepartmentGroup"(
	"DepartmentGroupKey" "int" IDENTITY(1,1) NOT NULL,
	"ParentDepartmentGroupKey" "int" NULL,
	"DepartmentGroupName" varchar(50) NULL,
 CONSTRAINT "PK_DimDepartmentGroup" PRIMARY KEY CLUSTERED 
(
	"DepartmentGroupKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimEmployee"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimEmployee"(
	"EmployeeKey" "int" IDENTITY(1,1) NOT NULL,
	"ParentEmployeeKey" "int" NULL,
	"EmployeeNationalIDAlternateKey" varchar(15) NULL,
	"ParentEmployeeNationalIDAlternateKey" varchar(15) NULL,
	"SalesTerritoryKey" "int" NULL,
	"FirstName" varchar(50) NOT NULL,
	"LastName" varchar(50) NOT NULL,
	"MiddleName" varchar(50) NULL,
	"NameStyle" "bit" NOT NULL,
	"Title" varchar(50) NULL,
	"HireDate" "date" NULL,
	"BirthDate" "date" NULL,
	"LoginID" varchar(256) NULL,
	"EmailAddress" varchar(50) NULL,
	"Phone" varchar(25) NULL,
	"MaritalStatus" "nchar"(1) NULL,
	"EmergencyContactName" varchar(50) NULL,
	"EmergencyContactPhone" varchar(25) NULL,
	"SalariedFlag" "bit" NULL,
	"Gender" "nchar"(1) NULL,
	"PayFrequency" "tinyint" NULL,
	"BaseRate" "money" NULL,
	"VacationHours" "smallint" NULL,
	"SickLeaveHours" "smallint" NULL,
	"CurrentFlag" "bit" NOT NULL,
	"SalesPersonFlag" "bit" NOT NULL,
	"DepartmentName" varchar(50) NULL,
	"StartDate" "date" NULL,
	"EndDate" "date" NULL,
	"Status" varchar(50) NULL,
	"EmployeePhoto" "varbinary"(max) NULL,
 CONSTRAINT "PK_DimEmployee_EmployeeKey" PRIMARY KEY CLUSTERED 
(
	"EmployeeKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY" TEXTIMAGE_ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimOrganization"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimOrganization"(
	"OrganizationKey" "int" IDENTITY(1,1) NOT NULL,
	"ParentOrganizationKey" "int" NULL,
	"PercentageOfOwnership" varchar(16) NULL,
	"OrganizationName" varchar(50) NULL,
	"CurrencyKey" "int" NULL,
 CONSTRAINT "PK_DimOrganization" PRIMARY KEY CLUSTERED 
(
	"OrganizationKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimPromotion"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimPromotion"(
	"PromotionKey" "int" IDENTITY(1,1) NOT NULL,
	"PromotionAlternateKey" "int" NULL,
	"EnglishPromotionName" varchar(255) NULL,
	"SpanishPromotionName" varchar(255) NULL,
	"FrenchPromotionName" varchar(255) NULL,
	"DiscountPct" "float" NULL,
	"EnglishPromotionType" varchar(50) NULL,
	"SpanishPromotionType" varchar(50) NULL,
	"FrenchPromotionType" varchar(50) NULL,
	"EnglishPromotionCategory" varchar(50) NULL,
	"SpanishPromotionCategory" varchar(50) NULL,
	"FrenchPromotionCategory" varchar(50) NULL,
	"StartDate" "datetime" NOT NULL,
	"EndDate" "datetime" NULL,
	"MinQty" "int" NULL,
	"MaxQty" "int" NULL,
 CONSTRAINT "PK_DimPromotion_PromotionKey" PRIMARY KEY CLUSTERED 
(
	"PromotionKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimPromotion_PromotionAlternateKey" UNIQUE NONCLUSTERED 
(
	"PromotionAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimReseller"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimReseller"(
	"ResellerKey" "int" IDENTITY(1,1) NOT NULL,
	"GeographyKey" "int" NULL,
	"ResellerAlternateKey" varchar(15) NULL,
	"Phone" varchar(25) NULL,
	"BusinessType" "varchar"(20) NOT NULL,
	"ResellerName" varchar(50) NOT NULL,
	"NumberEmployees" "int" NULL,
	"OrderFrequency" "char"(1) NULL,
	"OrderMonth" "tinyint" NULL,
	"FirstOrderYear" "int" NULL,
	"LastOrderYear" "int" NULL,
	"ProductLine" varchar(50) NULL,
	"AddressLine1" varchar(60) NULL,
	"AddressLine2" varchar(60) NULL,
	"AnnualSales" "money" NULL,
	"BankName" varchar(50) NULL,
	"MinPaymentType" "tinyint" NULL,
	"MinPaymentAmount" "money" NULL,
	"AnnualRevenue" "money" NULL,
	"YearOpened" "int" NULL,
 CONSTRAINT "PK_DimReseller_ResellerKey" PRIMARY KEY CLUSTERED 
(
	"ResellerKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_DimReseller_ResellerAlternateKey" UNIQUE NONCLUSTERED 
(
	"ResellerAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimSalesReason"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimSalesReason"(
	"SalesReasonKey" "int" IDENTITY(1,1) NOT NULL,
	"SalesReasonAlternateKey" "int" NOT NULL,
	"SalesReasonName" varchar(50) NOT NULL,
	"SalesReasonReasonType" varchar(50) NOT NULL,
 CONSTRAINT "PK_DimSalesReason_SalesReasonKey" PRIMARY KEY CLUSTERED 
(
	"SalesReasonKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."DimScenario"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."DimScenario"(
	"ScenarioKey" "int" IDENTITY(1,1) NOT NULL,
	"ScenarioName" varchar(50) NULL,
 CONSTRAINT "PK_DimScenario" PRIMARY KEY CLUSTERED 
(
	"ScenarioKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactAdditionalInternationalProductDescription"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactAdditionalInternationalProductDescription"(
	"ProductKey" "int" NOT NULL,
	"CultureName" varchar(50) NOT NULL,
	"ProductDescription" varchar(max) NOT NULL,
 CONSTRAINT "PK_FactAdditionalInternationalProductDescription_ProductKey_CultureName" PRIMARY KEY CLUSTERED 
(
	"ProductKey" ASC,
	"CultureName" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY" TEXTIMAGE_ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactCallCenter"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactCallCenter"(
	"FactCallCenterID" "int" IDENTITY(1,1) NOT NULL,
	"DateKey" "int" NOT NULL,
	"WageType" varchar(15) NOT NULL,
	"Shift" varchar(20) NOT NULL,
	"LevelOneOperators" "smallint" NOT NULL,
	"LevelTwoOperators" "smallint" NOT NULL,
	"TotalOperators" "smallint" NOT NULL,
	"Calls" "int" NOT NULL,
	"AutomaticResponses" "int" NOT NULL,
	"Orders" "int" NOT NULL,
	"IssuesRaised" "smallint" NOT NULL,
	"AverageTimePerIssue" "smallint" NOT NULL,
	"ServiceGrade" "float" NOT NULL,
	"Date" "datetime" NULL,
 CONSTRAINT "PK_FactCallCenter_FactCallCenterID" PRIMARY KEY CLUSTERED 
(
	"FactCallCenterID" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY",
 CONSTRAINT "AK_FactCallCenter_DateKey_Shift" UNIQUE NONCLUSTERED 
(
	"DateKey" ASC,
	"Shift" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactCurrencyRate"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactCurrencyRate"(
	"CurrencyKey" "int" NOT NULL,
	"DateKey" "int" NOT NULL,
	"AverageRate" "float" NOT NULL,
	"EndOfDayRate" "float" NOT NULL,
	"Date" "datetime" NULL,
 CONSTRAINT "PK_FactCurrencyRate_CurrencyKey_DateKey" PRIMARY KEY CLUSTERED 
(
	"CurrencyKey" ASC,
	"DateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactFinance"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactFinance"(
	"FinanceKey" "int" IDENTITY(1,1) NOT NULL,
	"DateKey" "int" NOT NULL,
	"OrganizationKey" "int" NOT NULL,
	"DepartmentGroupKey" "int" NOT NULL,
	"ScenarioKey" "int" NOT NULL,
	"AccountKey" "int" NOT NULL,
	"Amount" "float" NOT NULL,
	"Date" "datetime" NULL
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactInternetSalesReason"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactInternetSalesReason"(
	"SalesOrderNumber" varchar(20) NOT NULL,
	"SalesOrderLineNumber" "tinyint" NOT NULL,
	"SalesReasonKey" "int" NOT NULL,
 CONSTRAINT "PK_FactInternetSalesReason_SalesOrderNumber_SalesOrderLineNumber_SalesReasonKey" PRIMARY KEY CLUSTERED 
(
	"SalesOrderNumber" ASC,
	"SalesOrderLineNumber" ASC,
	"SalesReasonKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactProductInventory"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactProductInventory"(
	"ProductKey" "int" NOT NULL,
	"DateKey" "int" NOT NULL,
	"MovementDate" "date" NOT NULL,
	"UnitCost" "money" NOT NULL,
	"UnitsIn" "int" NOT NULL,
	"UnitsOut" "int" NOT NULL,
	"UnitsBalance" "int" NOT NULL,
 CONSTRAINT "PK_FactProductInventory" PRIMARY KEY CLUSTERED 
(
	"ProductKey" ASC,
	"DateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactResellerSales"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactResellerSales"(
	"ProductKey" "int" NOT NULL,
	"OrderDateKey" "int" NOT NULL,
	"DueDateKey" "int" NOT NULL,
	"ShipDateKey" "int" NOT NULL,
	"ResellerKey" "int" NOT NULL,
	"EmployeeKey" "int" NOT NULL,
	"PromotionKey" "int" NOT NULL,
	"CurrencyKey" "int" NOT NULL,
	"SalesTerritoryKey" "int" NOT NULL,
	"SalesOrderNumber" varchar(20) NOT NULL,
	"SalesOrderLineNumber" "tinyint" NOT NULL,
	"RevisionNumber" "tinyint" NULL,
	"OrderQuantity" "smallint" NULL,
	"UnitPrice" "money" NULL,
	"ExtendedAmount" "money" NULL,
	"UnitPriceDiscountPct" "float" NULL,
	"DiscountAmount" "float" NULL,
	"ProductStandardCost" "money" NULL,
	"TotalProductCost" "money" NULL,
	"SalesAmount" "money" NULL,
	"TaxAmt" "money" NULL,
	"Freight" "money" NULL,
	"CarrierTrackingNumber" varchar(25) NULL,
	"CustomerPONumber" varchar(25) NULL,
	"OrderDate" "datetime" NULL,
	"DueDate" "datetime" NULL,
	"ShipDate" "datetime" NULL,
 CONSTRAINT "PK_FactResellerSales_SalesOrderNumber_SalesOrderLineNumber" PRIMARY KEY CLUSTERED 
(
	"SalesOrderNumber" ASC,
	"SalesOrderLineNumber" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactSalesQuota"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactSalesQuota"(
	"SalesQuotaKey" "int" IDENTITY(1,1) NOT NULL,
	"EmployeeKey" "int" NOT NULL,
	"DateKey" "int" NOT NULL,
	"CalendarYear" "smallint" NOT NULL,
	"CalendarQuarter" "tinyint" NOT NULL,
	"SalesAmountQuota" "money" NOT NULL,
	"Date" "datetime" NULL,
 CONSTRAINT "PK_FactSalesQuota_SalesQuotaKey" PRIMARY KEY CLUSTERED 
(
	"SalesQuotaKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."FactSurveyResponse"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."FactSurveyResponse"(
	"SurveyResponseKey" "int" IDENTITY(1,1) NOT NULL,
	"DateKey" "int" NOT NULL,
	"CustomerKey" "int" NOT NULL,
	"ProductCategoryKey" "int" NOT NULL,
	"EnglishProductCategoryName" varchar(50) NOT NULL,
	"ProductSubcategoryKey" "int" NOT NULL,
	"EnglishProductSubcategoryName" varchar(50) NOT NULL,
	"Date" "datetime" NULL,
 CONSTRAINT "PK_FactSurveyResponse_SurveyResponseKey" PRIMARY KEY CLUSTERED 
(
	"SurveyResponseKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."NewFactCurrencyRate"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."NewFactCurrencyRate"(
	"AverageRate" "real" NULL,
	"CurrencyID" varchar(3) NULL,
	"CurrencyDate" "date" NULL,
	"EndOfDayRate" "real" NULL,
	"CurrencyKey" "int" NULL,
	"DateKey" "int" NULL
) ON "PRIMARY"
GO
/****** Object:  Table "dbo"."ProspectiveBuyer"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE "dbo"."ProspectiveBuyer"(
	"ProspectiveBuyerKey" "int" IDENTITY(1,1) NOT NULL,
	"ProspectAlternateKey" varchar(15) NULL,
	"FirstName" varchar(50) NULL,
	"MiddleName" varchar(50) NULL,
	"LastName" varchar(50) NULL,
	"BirthDate" "datetime" NULL,
	"MaritalStatus" "nchar"(1) NULL,
	"Gender" varchar(1) NULL,
	"EmailAddress" varchar(50) NULL,
	"YearlyIncome" "money" NULL,
	"TotalChildren" "tinyint" NULL,
	"NumberChildrenAtHome" "tinyint" NULL,
	"Education" varchar(40) NULL,
	"Occupation" varchar(100) NULL,
	"HouseOwnerFlag" "nchar"(1) NULL,
	"NumberCarsOwned" "tinyint" NULL,
	"AddressLine1" varchar(120) NULL,
	"AddressLine2" varchar(120) NULL,
	"City" varchar(30) NULL,
	"StateProvinceCode" varchar(3) NULL,
	"PostalCode" varchar(15) NULL,
	"Phone" varchar(20) NULL,
	"Salutation" varchar(8) NULL,
	"Unknown" "int" NULL,
 CONSTRAINT "PK_ProspectiveBuyer_ProspectiveBuyerKey" PRIMARY KEY CLUSTERED 
(
	"ProspectiveBuyerKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
) ON "PRIMARY"
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index "AK_DimCurrency_CurrencyAlternateKey"    Script Date: 25/09/2023 11:15:58 ******/
CREATE UNIQUE NONCLUSTERED INDEX "AK_DimCurrency_CurrencyAlternateKey" ON "dbo"."DimCurrency"
(
	"CurrencyAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index "IX_DimCustomer_CustomerAlternateKey"    Script Date: 25/09/2023 11:15:58 ******/
CREATE UNIQUE NONCLUSTERED INDEX "IX_DimCustomer_CustomerAlternateKey" ON "dbo"."DimCustomer"
(
	"CustomerAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
GO
/****** Object:  Index "AK_DimDate_FullDateAlternateKey"    Script Date: 25/09/2023 11:15:58 ******/
CREATE UNIQUE NONCLUSTERED INDEX "AK_DimDate_FullDateAlternateKey" ON "dbo"."DimDate"
(
	"FullDateAlternateKey" ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON "PRIMARY"
GO
ALTER TABLE "dbo"."DimAccount"  WITH CHECK ADD  CONSTRAINT "FK_DimAccount_DimAccount" FOREIGN KEY("ParentAccountKey")
REFERENCES "dbo"."DimAccount" ("AccountKey")
GO
ALTER TABLE "dbo"."DimAccount" CHECK CONSTRAINT "FK_DimAccount_DimAccount"
GO
ALTER TABLE "dbo"."DimCustomer"  WITH CHECK ADD  CONSTRAINT "FK_DimCustomer_DimGeography" FOREIGN KEY("GeographyKey")
REFERENCES "dbo"."DimGeography" ("GeographyKey")
GO
ALTER TABLE "dbo"."DimCustomer" CHECK CONSTRAINT "FK_DimCustomer_DimGeography"
GO
ALTER TABLE "dbo"."DimDepartmentGroup"  WITH CHECK ADD  CONSTRAINT "FK_DimDepartmentGroup_DimDepartmentGroup" FOREIGN KEY("ParentDepartmentGroupKey")
REFERENCES "dbo"."DimDepartmentGroup" ("DepartmentGroupKey")
GO
ALTER TABLE "dbo"."DimDepartmentGroup" CHECK CONSTRAINT "FK_DimDepartmentGroup_DimDepartmentGroup"
GO
ALTER TABLE "dbo"."DimEmployee"  WITH CHECK ADD  CONSTRAINT "FK_DimEmployee_DimEmployee" FOREIGN KEY("ParentEmployeeKey")
REFERENCES "dbo"."DimEmployee" ("EmployeeKey")
GO
ALTER TABLE "dbo"."DimEmployee" CHECK CONSTRAINT "FK_DimEmployee_DimEmployee"
GO
ALTER TABLE "dbo"."DimEmployee"  WITH CHECK ADD  CONSTRAINT "FK_DimEmployee_DimSalesTerritory" FOREIGN KEY("SalesTerritoryKey")
REFERENCES "dbo"."DimSalesTerritory" ("SalesTerritoryKey")
GO
ALTER TABLE "dbo"."DimEmployee" CHECK CONSTRAINT "FK_DimEmployee_DimSalesTerritory"
GO
ALTER TABLE "dbo"."DimGeography"  WITH CHECK ADD  CONSTRAINT "FK_DimGeography_DimSalesTerritory" FOREIGN KEY("SalesTerritoryKey")
REFERENCES "dbo"."DimSalesTerritory" ("SalesTerritoryKey")
GO
ALTER TABLE "dbo"."DimGeography" CHECK CONSTRAINT "FK_DimGeography_DimSalesTerritory"
GO
ALTER TABLE "dbo"."DimOrganization"  WITH CHECK ADD  CONSTRAINT "FK_DimOrganization_DimCurrency" FOREIGN KEY("CurrencyKey")
REFERENCES "dbo"."DimCurrency" ("CurrencyKey")
GO
ALTER TABLE "dbo"."DimOrganization" CHECK CONSTRAINT "FK_DimOrganization_DimCurrency"
GO
ALTER TABLE "dbo"."DimOrganization"  WITH CHECK ADD  CONSTRAINT "FK_DimOrganization_DimOrganization" FOREIGN KEY("ParentOrganizationKey")
REFERENCES "dbo"."DimOrganization" ("OrganizationKey")
GO
ALTER TABLE "dbo"."DimOrganization" CHECK CONSTRAINT "FK_DimOrganization_DimOrganization"
GO
ALTER TABLE "dbo"."DimProduct"  WITH CHECK ADD  CONSTRAINT "FK_DimProduct_DimProductSubcategory" FOREIGN KEY("ProductSubcategoryKey")
REFERENCES "dbo"."DimProductSubcategory" ("ProductSubcategoryKey")
GO
ALTER TABLE "dbo"."DimProduct" CHECK CONSTRAINT "FK_DimProduct_DimProductSubcategory"
GO
ALTER TABLE "dbo"."DimProductSubcategory"  WITH CHECK ADD  CONSTRAINT "FK_DimProductSubcategory_DimProductCategory" FOREIGN KEY("ProductCategoryKey")
REFERENCES "dbo"."DimProductCategory" ("ProductCategoryKey")
GO
ALTER TABLE "dbo"."DimProductSubcategory" CHECK CONSTRAINT "FK_DimProductSubcategory_DimProductCategory"
GO
ALTER TABLE "dbo"."DimReseller"  WITH CHECK ADD  CONSTRAINT "FK_DimReseller_DimGeography" FOREIGN KEY("GeographyKey")
REFERENCES "dbo"."DimGeography" ("GeographyKey")
GO
ALTER TABLE "dbo"."DimReseller" CHECK CONSTRAINT "FK_DimReseller_DimGeography"
GO
ALTER TABLE "dbo"."FactCallCenter"  WITH CHECK ADD  CONSTRAINT "FK_FactCallCenter_DimDate" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactCallCenter" CHECK CONSTRAINT "FK_FactCallCenter_DimDate"
GO
ALTER TABLE "dbo"."FactCurrencyRate"  WITH CHECK ADD  CONSTRAINT "FK_FactCurrencyRate_DimCurrency" FOREIGN KEY("CurrencyKey")
REFERENCES "dbo"."DimCurrency" ("CurrencyKey")
GO
ALTER TABLE "dbo"."FactCurrencyRate" CHECK CONSTRAINT "FK_FactCurrencyRate_DimCurrency"
GO
ALTER TABLE "dbo"."FactCurrencyRate"  WITH CHECK ADD  CONSTRAINT "FK_FactCurrencyRate_DimDate" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactCurrencyRate" CHECK CONSTRAINT "FK_FactCurrencyRate_DimDate"
GO
ALTER TABLE "dbo"."FactFinance"  WITH CHECK ADD  CONSTRAINT "FK_FactFinance_DimAccount" FOREIGN KEY("AccountKey")
REFERENCES "dbo"."DimAccount" ("AccountKey")
GO
ALTER TABLE "dbo"."FactFinance" CHECK CONSTRAINT "FK_FactFinance_DimAccount"
GO
ALTER TABLE "dbo"."FactFinance"  WITH CHECK ADD  CONSTRAINT "FK_FactFinance_DimDate" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactFinance" CHECK CONSTRAINT "FK_FactFinance_DimDate"
GO
ALTER TABLE "dbo"."FactFinance"  WITH CHECK ADD  CONSTRAINT "FK_FactFinance_DimDepartmentGroup" FOREIGN KEY("DepartmentGroupKey")
REFERENCES "dbo"."DimDepartmentGroup" ("DepartmentGroupKey")
GO
ALTER TABLE "dbo"."FactFinance" CHECK CONSTRAINT "FK_FactFinance_DimDepartmentGroup"
GO
ALTER TABLE "dbo"."FactFinance"  WITH CHECK ADD  CONSTRAINT "FK_FactFinance_DimOrganization" FOREIGN KEY("OrganizationKey")
REFERENCES "dbo"."DimOrganization" ("OrganizationKey")
GO
ALTER TABLE "dbo"."FactFinance" CHECK CONSTRAINT "FK_FactFinance_DimOrganization"
GO
ALTER TABLE "dbo"."FactFinance"  WITH CHECK ADD  CONSTRAINT "FK_FactFinance_DimScenario" FOREIGN KEY("ScenarioKey")
REFERENCES "dbo"."DimScenario" ("ScenarioKey")
GO
ALTER TABLE "dbo"."FactFinance" CHECK CONSTRAINT "FK_FactFinance_DimScenario"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimCurrency" FOREIGN KEY("CurrencyKey")
REFERENCES "dbo"."DimCurrency" ("CurrencyKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimCurrency"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimCustomer" FOREIGN KEY("CustomerKey")
REFERENCES "dbo"."DimCustomer" ("CustomerKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimCustomer"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimDate" FOREIGN KEY("OrderDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimDate"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimDate1" FOREIGN KEY("DueDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimDate1"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimDate2" FOREIGN KEY("ShipDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimDate2"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimProduct" FOREIGN KEY("ProductKey")
REFERENCES "dbo"."DimProduct" ("ProductKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimProduct"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimPromotion" FOREIGN KEY("PromotionKey")
REFERENCES "dbo"."DimPromotion" ("PromotionKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimPromotion"
GO
ALTER TABLE "dbo"."FactInternetSales"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSales_DimSalesTerritory" FOREIGN KEY("SalesTerritoryKey")
REFERENCES "dbo"."DimSalesTerritory" ("SalesTerritoryKey")
GO
ALTER TABLE "dbo"."FactInternetSales" CHECK CONSTRAINT "FK_FactInternetSales_DimSalesTerritory"
GO
ALTER TABLE "dbo"."FactInternetSalesReason"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSalesReason_DimSalesReason" FOREIGN KEY("SalesReasonKey")
REFERENCES "dbo"."DimSalesReason" ("SalesReasonKey")
GO
ALTER TABLE "dbo"."FactInternetSalesReason" CHECK CONSTRAINT "FK_FactInternetSalesReason_DimSalesReason"
GO
ALTER TABLE "dbo"."FactInternetSalesReason"  WITH CHECK ADD  CONSTRAINT "FK_FactInternetSalesReason_FactInternetSales" FOREIGN KEY("SalesOrderNumber", "SalesOrderLineNumber")
REFERENCES "dbo"."FactInternetSales" ("SalesOrderNumber", "SalesOrderLineNumber")
GO
ALTER TABLE "dbo"."FactInternetSalesReason" CHECK CONSTRAINT "FK_FactInternetSalesReason_FactInternetSales"
GO
ALTER TABLE "dbo"."FactProductInventory"  WITH CHECK ADD  CONSTRAINT "FK_FactProductInventory_DimDate" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactProductInventory" CHECK CONSTRAINT "FK_FactProductInventory_DimDate"
GO
ALTER TABLE "dbo"."FactProductInventory"  WITH CHECK ADD  CONSTRAINT "FK_FactProductInventory_DimProduct" FOREIGN KEY("ProductKey")
REFERENCES "dbo"."DimProduct" ("ProductKey")
GO
ALTER TABLE "dbo"."FactProductInventory" CHECK CONSTRAINT "FK_FactProductInventory_DimProduct"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimCurrency" FOREIGN KEY("CurrencyKey")
REFERENCES "dbo"."DimCurrency" ("CurrencyKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimCurrency"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimDate" FOREIGN KEY("OrderDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimDate"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimDate1" FOREIGN KEY("DueDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimDate1"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimDate2" FOREIGN KEY("ShipDateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimDate2"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimEmployee" FOREIGN KEY("EmployeeKey")
REFERENCES "dbo"."DimEmployee" ("EmployeeKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimEmployee"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimProduct" FOREIGN KEY("ProductKey")
REFERENCES "dbo"."DimProduct" ("ProductKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimProduct"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimPromotion" FOREIGN KEY("PromotionKey")
REFERENCES "dbo"."DimPromotion" ("PromotionKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimPromotion"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimReseller" FOREIGN KEY("ResellerKey")
REFERENCES "dbo"."DimReseller" ("ResellerKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimReseller"
GO
ALTER TABLE "dbo"."FactResellerSales"  WITH CHECK ADD  CONSTRAINT "FK_FactResellerSales_DimSalesTerritory" FOREIGN KEY("SalesTerritoryKey")
REFERENCES "dbo"."DimSalesTerritory" ("SalesTerritoryKey")
GO
ALTER TABLE "dbo"."FactResellerSales" CHECK CONSTRAINT "FK_FactResellerSales_DimSalesTerritory"
GO
ALTER TABLE "dbo"."FactSalesQuota"  WITH CHECK ADD  CONSTRAINT "FK_FactSalesQuota_DimDate" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactSalesQuota" CHECK CONSTRAINT "FK_FactSalesQuota_DimDate"
GO
ALTER TABLE "dbo"."FactSalesQuota"  WITH CHECK ADD  CONSTRAINT "FK_FactSalesQuota_DimEmployee" FOREIGN KEY("EmployeeKey")
REFERENCES "dbo"."DimEmployee" ("EmployeeKey")
GO
ALTER TABLE "dbo"."FactSalesQuota" CHECK CONSTRAINT "FK_FactSalesQuota_DimEmployee"
GO
ALTER TABLE "dbo"."FactSurveyResponse"  WITH CHECK ADD  CONSTRAINT "FK_FactSurveyResponse_CustomerKey" FOREIGN KEY("CustomerKey")
REFERENCES "dbo"."DimCustomer" ("CustomerKey")
GO
ALTER TABLE "dbo"."FactSurveyResponse" CHECK CONSTRAINT "FK_FactSurveyResponse_CustomerKey"
GO
ALTER TABLE "dbo"."FactSurveyResponse"  WITH CHECK ADD  CONSTRAINT "FK_FactSurveyResponse_DateKey" FOREIGN KEY("DateKey")
REFERENCES "dbo"."DimDate" ("DateKey")
GO
ALTER TABLE "dbo"."FactSurveyResponse" CHECK CONSTRAINT "FK_FactSurveyResponse_DateKey"
GO
/****** Object:  DdlTrigger "ddlDatabaseTriggerLog"    Script Date: 25/09/2023 11:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER "ddlDatabaseTriggerLog" ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema sysname;
    DECLARE @object sysname;
    DECLARE @eventType sysname;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)"1"', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)"1"', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)"1"', 'sysname') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT "dbo"."DatabaseLog" 
        (
        "PostTime", 
        "DatabaseUser", 
        "Event", 
        "Schema", 
        "Object", 
        "TSQL", 
        "XmlEvent"
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT(sysname, CURRENT_USER), 
        @eventType, 
        CONVERT(sysname, @schema), 
        CONVERT(sysname, @object), 
        @data.value('(/EVENT_INSTANCE/TSQLCommand)"1"', 'nvarchar(max)'), 
        @data
        );
END;
GO
DISABLE TRIGGER "ddlDatabaseTriggerLog" ON DATABASE
GO
USE "master"
GO
ALTER DATABASE "AdventureWorksDW2022" SET  READ_WRITE 
GO
