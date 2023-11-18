/*============================================================================
  File:     instawdb.sql

  Summary:  Creates the AdventureWorksDW sample database. Run this on
  any version of SQL Server (2008R2 or later) to get AdventureWorksDW for your
  current version.  

  Date:     October 26, 2017
  Updated:  October 26, 2017

------------------------------------------------------------------------------

============================================================================*/

/*
 * HOW TO RUN THIS SCRIPT:
 *
 * 1. Enable full-text search on your SQL Server instance. 
 *
 * 2. Open the script inside SQL Server Management Studio and enable SQLCMD mode. 
 *    This option is in the Query menu.
 *
 * 3. Copy this script and the install files to C:\Samples\AdventureWorksDW, or
 *    set the following environment variable to your own data path.
 *
 * 4. Append the SQL Server version number to database name if you want to
 *    differentiate it from other installs of AdventureWorksDW
 */


-- ****************************************
-- Create User defined functions
-- ****************************************

CREATE OR REPLACE FUNCTION "udfTwoDigitZeroFill"(number integer)
    RETURNS char(2)
AS
$$
DECLARE
    result char(2);
BEGIN
    IF number > 9 THEN
        result := number::text;
    ELSE
        result := '0' || number::text;
    END IF;

    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "udfBuildISO8601Date"(year int, month int, day int)
    RETURNS timestamp
AS
$$
BEGIN
    RETURN (year::text || '-' || "udfTwoDigitZeroFill"(
            month) || '-' || "udfTwoDigitZeroFill"(
                    day) || 'T00:00:00')::timestamp;
END;
$$ LANGUAGE plpgsql;


-- ****************************************
-- Create Tables
-- ****************************************

CREATE OR REPLACE FUNCTION "udfMinimumDate"(x timestamp, y timestamp)
    RETURNS timestamp AS
$$
DECLARE
    z timestamp;
BEGIN
    IF x <= y THEN
        z := x;
    ELSE
        z := y;
    END IF;

    RETURN z;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE "DimCustomer"
(
    "CustomerKey"          serial       NOT NULL,
    "GeographyKey"         int          NULL,
    "CustomerAlternateKey" varchar(15)  NOT NULL,
    "Title"                varchar(8)   NULL,
    "FirstName"            varchar(50)  NULL,
    "MiddleName"           varchar(50)  NULL,
    "LastName"             varchar(50)  NULL,
    "NameStyle"            "bit"        NULL,
    "BirthDate"            "date"       NULL,
    "MaritalStatus"        char(1)      NULL,
    "Suffix"               varchar(10)  NULL,
    "Gender"               varchar(1)   NULL,
    "EmailAddress"         varchar(50)  NULL,
    "YearlyIncome"         money        NULL,
    "TotalChildren"        smallint     NULL,
    "NumberChildrenAtHome" smallint     NULL,
    "EnglishEducation"     varchar(40)  NULL,
    "SpanishEducation"     varchar(40)  NULL,
    "FrenchEducation"      varchar(40)  NULL,
    "EnglishOccupation"    varchar(100) NULL,
    "SpanishOccupation"    varchar(100) NULL,
    "FrenchOccupation"     varchar(100) NULL,
    "HouseOwnerFlag"       char(1)      NULL,
    "NumberCarsOwned"      smallint     NULL,
    "AddressLine1"         varchar(120) NULL,
    "AddressLine2"         varchar(120) NULL,
    "Phone"                varchar(20)  NULL,
    "DateFirstPurchase"    "date"       NULL,
    "CommuteDistance"      varchar(15)  NULL,
    CONSTRAINT "PK_DimCustomer_CustomerKey" PRIMARY KEY ("CustomerKey")
);

CREATE TABLE "DimDate"
(
    "DateKey"              int         NOT NULL,
    "FullDateAlternateKey" "date"      NOT NULL,
    "DayNumberOfWeek"      smallint    NOT NULL,
    "EnglishDayNameOfWeek" varchar(10) NOT NULL,
    "SpanishDayNameOfWeek" varchar(10) NOT NULL,
    "FrenchDayNameOfWeek"  varchar(10) NOT NULL,
    "DayNumberOfMonth"     smallint    NOT NULL,
    "DayNumberOfYear"      smallint    NOT NULL,
    "WeekNumberOfYear"     smallint    NOT NULL,
    "EnglishMonthName"     varchar(10) NOT NULL,
    "SpanishMonthName"     varchar(10) NOT NULL,
    "FrenchMonthName"      varchar(10) NOT NULL,
    "MonthNumberOfYear"    smallint    NOT NULL,
    "CalendarQuarter"      smallint    NOT NULL,
    "CalendarYear"         smallint    NOT NULL,
    "CalendarSemester"     smallint    NOT NULL,
    "FiscalQuarter"        smallint    NOT NULL,
    "FiscalYear"           smallint    NOT NULL,
    "FiscalSemester"       smallint    NOT NULL,
    CONSTRAINT "PK_DimDate_DateKey" PRIMARY KEY ("DateKey")
);

CREATE TABLE "DimGeography"
(
    "GeographyKey"             serial      NOT NULL,
    "City"                     varchar(30) NULL,
    "StateProvinceCode"        varchar(3)  NULL,
    "StateProvinceName"        varchar(50) NULL,
    "CountryRegionCode"        varchar(3)  NULL,
    "EnglishCountryRegionName" varchar(50) NULL,
    "SpanishCountryRegionName" varchar(50) NULL,
    "FrenchCountryRegionName"  varchar(50) NULL,
    "PostalCode"               varchar(15) NULL,
    "SalesTerritoryKey"        int         NULL,
    "IpAddressLocator"         varchar(15) NULL,
    CONSTRAINT "PK_DimGeography_GeographyKey" PRIMARY KEY ("GeographyKey")
);

CREATE TABLE "DimProduct"
(
    "ProductKey"            serial       NOT NULL,
    "ProductAlternateKey"   varchar(25)  NULL,
    "ProductSubcategoryKey" int          NULL,
    "WeightUnitMeasureCode" char(3)      NULL,
    "SizeUnitMeasureCode"   char(3)      NULL,
    "EnglishProductName"    varchar(50)  NOT NULL,
    "SpanishProductName"    varchar(50)  NOT NULL,
    "FrenchProductName"     varchar(50)  NOT NULL,
    "StandardCost"          money        NULL,
    "FinishedGoodsFlag"     "bit"        NOT NULL,
    "Color"                 varchar(15)  NOT NULL,
    "SafetyStockLevel"      smallint     NULL,
    "ReorderPoint"          smallint     NULL,
    "ListPrice"             money        NULL,
    "Size"                  varchar(50)  NULL,
    "SizeRange"             varchar(50)  NULL,
    "Weight"                float        NULL,
    "DaysToManufacture"     int          NULL,
    "ProductLine"           char(2)      NULL,
    "DealerPrice"           money        NULL,
    "Class"                 char(2)      NULL,
    "Style"                 char(2)      NULL,
    "ModelName"             varchar(50)  NULL,
    "LargePhoto"            BYTEA        NULL,
    "EnglishDescription"    varchar(400) NULL,
    "FrenchDescription"     varchar(400) NULL,
    "ChineseDescription"    varchar(400) NULL,
    "ArabicDescription"     varchar(400) NULL,
    "HebrewDescription"     varchar(400) NULL,
    "ThaiDescription"       varchar(400) NULL,
    "GermanDescription"     varchar(400) NULL,
    "JapaneseDescription"   varchar(400) NULL,
    "TurkishDescription"    varchar(400) NULL,
    "StartDate"             TIMESTAMP(3) NULL,
    "EndDate"               TIMESTAMP(3) NULL,
    "Status"                varchar(7)   NULL,
    CONSTRAINT "PK_DimProduct_ProductKey" PRIMARY KEY ("ProductKey"),
    CONSTRAINT "AK_DimProduct_ProductAlternateKey_StartDate" UNIQUE
        (
         "ProductAlternateKey",
         "StartDate"
            )
);

CREATE TABLE "DimProductCategory"
(
    "ProductCategoryKey"          serial      NOT NULL,
    "ProductCategoryAlternateKey" int         NULL,
    "EnglishProductCategoryName"  varchar(50) NOT NULL,
    "SpanishProductCategoryName"  varchar(50) NOT NULL,
    "FrenchProductCategoryName"   varchar(50) NOT NULL,
    CONSTRAINT "PK_DimProductCategory_ProductCategoryKey" PRIMARY KEY ("ProductCategoryKey"),
    CONSTRAINT "AK_DimProductCategory_ProductCategoryAlternateKey" UNIQUE
        ("ProductCategoryAlternateKey")
);

CREATE TABLE "DimProductSubcategory"
(
    "ProductSubcategoryKey"          serial      NOT NULL,
    "ProductSubcategoryAlternateKey" int         NULL,
    "EnglishProductSubcategoryName"  varchar(50) NOT NULL,
    "SpanishProductSubcategoryName"  varchar(50) NOT NULL,
    "FrenchProductSubcategoryName"   varchar(50) NOT NULL,
    "ProductCategoryKey"             int         NULL,
    CONSTRAINT "PK_DimProductSubcategory_ProductSubcategoryKey" PRIMARY KEY
        (
         "ProductSubcategoryKey"
            ),
    CONSTRAINT "AK_DimProductSubcategory_ProductSubcategoryAlternateKey" UNIQUE
        (
         "ProductSubcategoryAlternateKey"
            )
);

CREATE TABLE "DimSalesTerritory"
(
    "SalesTerritoryKey"          serial      NOT NULL,
    "SalesTerritoryAlternateKey" int         NULL,
    "SalesTerritoryRegion"       varchar(50) NOT NULL,
    "SalesTerritoryCountry"      varchar(50) NOT NULL,
    "SalesTerritoryGroup"        varchar(50) NULL,
    "SalesTerritoryImage"        BYTEA       NULL,
    CONSTRAINT "PK_DimSalesTerritory_SalesTerritoryKey" PRIMARY KEY ("SalesTerritoryKey"),
    CONSTRAINT "AK_DimSalesTerritory_SalesTerritoryAlternateKey" UNIQUE ("SalesTerritoryAlternateKey")
);

CREATE TABLE "FactInternetSales"
(
    "ProductKey"            int          NOT NULL,
    "OrderDateKey"          int          NOT NULL,
    "DueDateKey"            int          NOT NULL,
    "ShipDateKey"           int          NOT NULL,
    "CustomerKey"           int          NOT NULL,
    "PromotionKey"          int          NOT NULL,
    "CurrencyKey"           int          NOT NULL,
    "SalesTerritoryKey"     int          NOT NULL,
    "SalesOrderNumber"      varchar(20)  NOT NULL,
    "SalesOrderLineNumber"  smallint     NOT NULL,
    "RevisionNumber"        smallint     NOT NULL,
    "OrderQuantity"         smallint     NOT NULL,
    "UnitPrice"             money        NOT NULL,
    "ExtendedAmount"        money        NOT NULL,
    "UnitPriceDiscountPct"  float        NOT NULL,
    "DiscountAmount"        float        NOT NULL,
    "ProductStandardCost"   money        NOT NULL,
    "TotalProductCost"      money        NOT NULL,
    "SalesAmount"           money        NOT NULL,
    "TaxAmt"                money        NOT NULL,
    "Freight"               money        NOT NULL,
    "CarrierTrackingNumber" varchar(25)  NULL,
    "CustomerPONumber"      varchar(25)  NULL,
    "OrderDate"             TIMESTAMP(3) NULL,
    "DueDate"               TIMESTAMP(3) NULL,
    "ShipDate"              TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber" PRIMARY KEY
        (
         "SalesOrderNumber",
         "SalesOrderLineNumber"
            )
);
CREATE TABLE "DimAccount"
(
    "AccountKey"                    serial       NOT NULL,
    "ParentAccountKey"              int          NULL,
    "AccountCodeAlternateKey"       int          NULL,
    "ParentAccountCodeAlternateKey" int          NULL,
    "AccountDescription"            varchar(50)  NULL,
    "AccountType"                   varchar(50)  NULL,
    "Operator"                      varchar(50)  NULL,
    "CustomMembers"                 varchar(300) NULL,
    "ValueType"                     varchar(50)  NULL,
    "CustomMemberOptions"           varchar(200) NULL,
    CONSTRAINT "PK_DimAccount" PRIMARY KEY ("AccountKey")
);


CREATE TABLE "DimCurrency"
(
    "CurrencyKey"          serial      NOT NULL,
    "CurrencyAlternateKey" char(3)     NOT NULL,
    "CurrencyName"         varchar(50) NOT NULL,
    CONSTRAINT "PK_DimCurrency_CurrencyKey" PRIMARY KEY ("CurrencyKey")
);

CREATE TABLE "DimDepartmentGroup"
(
    "DepartmentGroupKey"       serial      NOT NULL,
    "ParentDepartmentGroupKey" int         NULL,
    "DepartmentGroupName"      varchar(50) NULL,
    CONSTRAINT "PK_DimDepartmentGroup" PRIMARY KEY ("DepartmentGroupKey")
);

CREATE TABLE "DimEmployee"
(
    "EmployeeKey"                          serial       NOT NULL,
    "ParentEmployeeKey"                    int          NULL,
    "EmployeeNationalIDAlternateKey"       varchar(15)  NULL,
    "ParentEmployeeNationalIDAlternateKey" varchar(15)  NULL,
    "SalesTerritoryKey"                    int          NULL,
    "FirstName"                            varchar(50)  NOT NULL,
    "LastName"                             varchar(50)  NOT NULL,
    "MiddleName"                           varchar(50)  NULL,
    "NameStyle"                            "bit"        NOT NULL,
    "Title"                                varchar(50)  NULL,
    "HireDate"                             "date"       NULL,
    "BirthDate"                            "date"       NULL,
    "LoginID"                              varchar(256) NULL,
    "EmailAddress"                         varchar(50)  NULL,
    "Phone"                                varchar(25)  NULL,
    "MaritalStatus"                        char(1)      NULL,
    "EmergencyContactName"                 varchar(50)  NULL,
    "EmergencyContactPhone"                varchar(25)  NULL,
    "SalariedFlag"                         "bit"        NULL,
    "Gender"                               char(1)      NULL,
    "PayFrequency"                         smallint     NULL,
    "BaseRate"                             money        NULL,
    "VacationHours"                        smallint     NULL,
    "SickLeaveHours"                       smallint     NULL,
    "CurrentFlag"                          "bit"        NOT NULL,
    "SalesPersonFlag"                      "bit"        NOT NULL,
    "DepartmentName"                       varchar(50)  NULL,
    "StartDate"                            "date"       NULL,
    "EndDate"                              "date"       NULL,
    "Status"                               varchar(50)  NULL,
    "EmployeePhoto"                        BYTEA        NULL,
    CONSTRAINT "PK_DimEmployee_EmployeeKey" PRIMARY KEY ("EmployeeKey")
);


CREATE TABLE "DimOrganization"
(
    "OrganizationKey"       serial      NOT NULL,
    "ParentOrganizationKey" int         NULL,
    "PercentageOfOwnership" varchar(16) NULL,
    "OrganizationName"      varchar(50) NULL,
    "CurrencyKey"           int         NULL,
    CONSTRAINT "PK_DimOrganization" PRIMARY KEY
        (
         "OrganizationKey"
            )
);


CREATE TABLE "DimPromotion"
(
    "PromotionKey"             serial       NOT NULL,
    "PromotionAlternateKey"    int          NULL,
    "EnglishPromotionName"     varchar(255) NULL,
    "SpanishPromotionName"     varchar(255) NULL,
    "FrenchPromotionName"      varchar(255) NULL,
    "DiscountPct"              float        NULL,
    "EnglishPromotionType"     varchar(50)  NULL,
    "SpanishPromotionType"     varchar(50)  NULL,
    "FrenchPromotionType"      varchar(50)  NULL,
    "EnglishPromotionCategory" varchar(50)  NULL,
    "SpanishPromotionCategory" varchar(50)  NULL,
    "FrenchPromotionCategory"  varchar(50)  NULL,
    "StartDate"                TIMESTAMP(3) NOT NULL,
    "EndDate"                  TIMESTAMP(3) NULL,
    "MinQty"                   int          NULL,
    "MaxQty"                   int          NULL,
    CONSTRAINT "PK_DimPromotion_PromotionKey" PRIMARY KEY
        (
         "PromotionKey"
            ),
    CONSTRAINT "AK_DimPromotion_PromotionAlternateKey" UNIQUE
        (
         "PromotionAlternateKey"
            )
);

CREATE TABLE "DimReseller"
(
    "ResellerKey"          serial        NOT NULL,
    "GeographyKey"         int           NULL,
    "ResellerAlternateKey" varchar(15)   NULL,
    "Phone"                varchar(25)   NULL,
    "BusinessType"         "varchar"(20) NOT NULL,
    "ResellerName"         varchar(50)   NOT NULL,
    "NumberEmployees"      int           NULL,
    "OrderFrequency"       char(1)       NULL,
    "OrderMonth"           smallint      NULL,
    "FirstOrderYear"       int           NULL,
    "LastOrderYear"        int           NULL,
    "ProductLine"          varchar(50)   NULL,
    "AddressLine1"         varchar(60)   NULL,
    "AddressLine2"         varchar(60)   NULL,
    "AnnualSales"          money         NULL,
    "BankName"             varchar(50)   NULL,
    "MinPaymentType"       smallint      NULL,
    "MinPaymentAmount"     money         NULL,
    "AnnualRevenue"        money         NULL,
    "YearOpened"           int           NULL,
    CONSTRAINT "PK_DimReseller_ResellerKey" PRIMARY KEY
        (
         "ResellerKey"
            ),
    CONSTRAINT "AK_DimReseller_ResellerAlternateKey" UNIQUE
        (
         "ResellerAlternateKey"
            )
);

CREATE TABLE "DimSalesReason"
(
    "SalesReasonKey"          serial      NOT NULL,
    "SalesReasonAlternateKey" int         NOT NULL,
    "SalesReasonName"         varchar(50) NOT NULL,
    "SalesReasonReasonType"   varchar(50) NOT NULL,
    CONSTRAINT "PK_DimSalesReason_SalesReasonKey" PRIMARY KEY
        (
         "SalesReasonKey"
            )
);

CREATE TABLE "DimScenario"
(
    "ScenarioKey"  serial      NOT NULL,
    "ScenarioName" varchar(50) NULL,
    CONSTRAINT "PK_DimScenario" PRIMARY KEY
        (
         "ScenarioKey"
            )
);

CREATE TABLE "FactAdditionalInternationalProductDescription"
(
    "ProductKey"         int         NOT NULL,
    "CultureName"        varchar(50) NOT NULL,
    "ProductDescription" text        NOT NULL,
    CONSTRAINT "PK_FactAdditionalInternationalProductDescription" PRIMARY KEY
        (
         "ProductKey",
         "CultureName"
            )
);

CREATE TABLE "FactCallCenter"
(
    "FactCallCenterID"    serial       NOT NULL,
    "DateKey"             int          NOT NULL,
    "WageType"            varchar(15)  NOT NULL,
    "Shift"               varchar(20)  NOT NULL,
    "LevelOneOperators"   smallint     NOT NULL,
    "LevelTwoOperators"   smallint     NOT NULL,
    "TotalOperators"      smallint     NOT NULL,
    "Calls"               int          NOT NULL,
    "AutomaticResponses"  int          NOT NULL,
    "Orders"              int          NOT NULL,
    "IssuesRaised"        smallint     NOT NULL,
    "AverageTimePerIssue" smallint     NOT NULL,
    "ServiceGrade"        float        NOT NULL,
    "Date"                TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactCallCenter_FactCallCenterID" PRIMARY KEY
        (
         "FactCallCenterID"
            ),
    CONSTRAINT "AK_FactCallCenter_DateKey_Shift" UNIQUE
        (
         "DateKey",
         "Shift"
            )
);
;
CREATE TABLE "FactCurrencyRate"
(
    "CurrencyKey"  int          NOT NULL,
    "DateKey"      int          NOT NULL,
    "AverageRate"  float        NOT NULL,
    "EndOfDayRate" float        NOT NULL,
    "Date"         TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactCurrencyRate_CurrencyKey_DateKey" PRIMARY KEY
        (
         "CurrencyKey",
         "DateKey"
            )
);
;
CREATE TABLE "FactFinance"
(
    "FinanceKey"         serial       NOT NULL,
    "DateKey"            int          NOT NULL,
    "OrganizationKey"    int          NOT NULL,
    "DepartmentGroupKey" int          NOT NULL,
    "ScenarioKey"        int          NOT NULL,
    "AccountKey"         int          NOT NULL,
    "Amount"             float        NOT NULL,
    "Date"               TIMESTAMP(3) NULL
);
;
CREATE TABLE "FactInternetSalesReason"
(
    "SalesOrderNumber"     varchar(20) NOT NULL,
    "SalesOrderLineNumber" smallint    NOT NULL,
    "SalesReasonKey"       int         NOT NULL,
    CONSTRAINT "PK_FactInternetSalesReason_SalesOrderNumber" PRIMARY KEY
        (
         "SalesOrderNumber",
         "SalesOrderLineNumber",
         "SalesReasonKey"
            )
);

CREATE TABLE "FactProductInventory"
(
    "ProductKey"   int    NOT NULL,
    "DateKey"      int    NOT NULL,
    "MovementDate" "date" NOT NULL,
    "UnitCost"     money  NOT NULL,
    "UnitsIn"      int    NOT NULL,
    "UnitsOut"     int    NOT NULL,
    "UnitsBalance" int    NOT NULL,
    CONSTRAINT "PK_FactProductInventory" PRIMARY KEY
        (
         "ProductKey",
         "DateKey"
            )
);

CREATE TABLE "FactResellerSales"
(
    "ProductKey"            int          NOT NULL,
    "OrderDateKey"          int          NOT NULL,
    "DueDateKey"            int          NOT NULL,
    "ShipDateKey"           int          NOT NULL,
    "ResellerKey"           int          NOT NULL,
    "EmployeeKey"           int          NOT NULL,
    "PromotionKey"          int          NOT NULL,
    "CurrencyKey"           int          NOT NULL,
    "SalesTerritoryKey"     int          NOT NULL,
    "SalesOrderNumber"      varchar(20)  NOT NULL,
    "SalesOrderLineNumber"  smallint     NOT NULL,
    "RevisionNumber"        smallint     NULL,
    "OrderQuantity"         smallint     NULL,
    "UnitPrice"             money        NULL,
    "ExtendedAmount"        money        NULL,
    "UnitPriceDiscountPct"  float        NULL,
    "DiscountAmount"        float        NULL,
    "ProductStandardCost"   money        NULL,
    "TotalProductCost"      money        NULL,
    "SalesAmount"           money        NULL,
    "TaxAmt"                money        NULL,
    "Freight"               money        NULL,
    "CarrierTrackingNumber" varchar(25)  NULL,
    "CustomerPONumber"      varchar(25)  NULL,
    "OrderDate"             TIMESTAMP(3) NULL,
    "DueDate"               TIMESTAMP(3) NULL,
    "ShipDate"              TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactResellerSales_SalesOrderNumber_SalesOrderLineNumber" PRIMARY KEY
        (
         "SalesOrderNumber",
         "SalesOrderLineNumber"
            )
);

CREATE TABLE "FactSalesQuota"
(
    "SalesQuotaKey"    serial       NOT NULL,
    "EmployeeKey"      int          NOT NULL,
    "DateKey"          int          NOT NULL,
    "CalendarYear"     smallint     NOT NULL,
    "CalendarQuarter"  smallint     NOT NULL,
    "SalesAmountQuota" money        NOT NULL,
    "Date"             TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactSalesQuota_SalesQuotaKey" PRIMARY KEY ("SalesQuotaKey")
);

CREATE TABLE "FactSurveyResponse"
(
    "SurveyResponseKey"             serial       NOT NULL,
    "DateKey"                       int          NOT NULL,
    "CustomerKey"                   int          NOT NULL,
    "ProductCategoryKey"            int          NOT NULL,
    "EnglishProductCategoryName"    varchar(50)  NOT NULL,
    "ProductSubcategoryKey"         int          NOT NULL,
    "EnglishProductSubcategoryName" varchar(50)  NOT NULL,
    "Date"                          TIMESTAMP(3) NULL,
    CONSTRAINT "PK_FactSurveyResponse_SurveyResponseKey" PRIMARY KEY ("SurveyResponseKey")
);
;
CREATE TABLE "NewFactCurrencyRate"
(
    "AverageRate"  real       NULL,
    "CurrencyID"   varchar(3) NULL,
    "CurrencyDate" "date"     NULL,
    "EndOfDayRate" real       NULL,
    "CurrencyKey"  int        NULL,
    "DateKey"      int        NULL
);
;
CREATE TABLE "ProspectiveBuyer"
(
    "ProspectiveBuyerKey"  serial       NOT NULL,
    "ProspectAlternateKey" varchar(15)  NULL,
    "FirstName"            varchar(50)  NULL,
    "MiddleName"           varchar(50)  NULL,
    "LastName"             varchar(50)  NULL,
    "BirthDate"            TIMESTAMP(3) NULL,
    "MaritalStatus"        char(1)      NULL,
    "Gender"               varchar(1)   NULL,
    "EmailAddress"         varchar(50)  NULL,
    "YearlyIncome"         money        NULL,
    "TotalChildren"        smallint     NULL,
    "NumberChildrenAtHome" smallint     NULL,
    "Education"            varchar(40)  NULL,
    "Occupation"           varchar(100) NULL,
    "HouseOwnerFlag"       char(1)      NULL,
    "NumberCarsOwned"      smallint     NULL,
    "AddressLine1"         varchar(120) NULL,
    "AddressLine2"         varchar(120) NULL,
    "City"                 varchar(30)  NULL,
    "StateProvinceCode"    varchar(3)   NULL,
    "PostalCode"           varchar(15)  NULL,
    "Phone"                varchar(20)  NULL,
    "Salutation"           varchar(8)   NULL,
    "Unknown"              int          NULL,
    CONSTRAINT "PK_ProspectiveBuyer_ProspectiveBuyerKey" PRIMARY KEY ("ProspectiveBuyerKey")
);


CREATE UNIQUE INDEX "AK_DimCurrency_CurrencyAlternateKey" ON "DimCurrency" ("CurrencyAlternateKey");
CREATE UNIQUE INDEX "IX_DimCustomer_CustomerAlternateKey" ON "DimCustomer" ("CustomerAlternateKey");
CREATE UNIQUE INDEX "AK_DimDate_FullDateAlternateKey" ON "DimDate" ("FullDateAlternateKey");

ALTER TABLE "DimAccount"
    ADD CONSTRAINT "FK_DimAccount_DimAccount"
        FOREIGN KEY ("ParentAccountKey")
            REFERENCES "DimAccount" ("AccountKey");

ALTER TABLE "DimCustomer"
    ADD CONSTRAINT "FK_DimCustomer_DimGeography"
        FOREIGN KEY ("GeographyKey")
            REFERENCES "DimGeography" ("GeographyKey");

ALTER TABLE "DimDepartmentGroup"
    ADD CONSTRAINT "FK_DimDepartmentGroup_DimDepartmentGroup"
        FOREIGN KEY ("ParentDepartmentGroupKey")
            REFERENCES "DimDepartmentGroup" ("DepartmentGroupKey");

ALTER TABLE "DimEmployee"
    ADD CONSTRAINT "FK_DimEmployee_DimEmployee"
        FOREIGN KEY ("ParentEmployeeKey")
            REFERENCES "DimEmployee" ("EmployeeKey");

ALTER TABLE "DimEmployee"
    ADD CONSTRAINT "FK_DimEmployee_DimSalesTerritory"
        FOREIGN KEY ("SalesTerritoryKey")
            REFERENCES "DimSalesTerritory" ("SalesTerritoryKey");

ALTER TABLE "DimGeography"
    ADD CONSTRAINT "FK_DimGeography_DimSalesTerritory"
        FOREIGN KEY ("SalesTerritoryKey")
            REFERENCES "DimSalesTerritory" ("SalesTerritoryKey");

ALTER TABLE "DimOrganization"
    ADD CONSTRAINT "FK_DimOrganization_DimCurrency"
        FOREIGN KEY ("CurrencyKey")
            REFERENCES "DimCurrency" ("CurrencyKey");

ALTER TABLE "DimOrganization"
    ADD CONSTRAINT "FK_DimOrganization_DimOrganization"
        FOREIGN KEY ("ParentOrganizationKey")
            REFERENCES "DimOrganization" ("OrganizationKey");

ALTER TABLE "DimProduct"
    ADD CONSTRAINT "FK_DimProduct_DimProductSubcategory"
        FOREIGN KEY ("ProductSubcategoryKey")
            REFERENCES "DimProductSubcategory" ("ProductSubcategoryKey");

ALTER TABLE "DimProductSubcategory"
    ADD CONSTRAINT "FK_DimProductSubcategory_DimProductCategory"
        FOREIGN KEY ("ProductCategoryKey")
            REFERENCES "DimProductCategory" ("ProductCategoryKey");

ALTER TABLE "DimReseller"
    ADD CONSTRAINT "FK_DimReseller_DimGeography"
        FOREIGN KEY ("GeographyKey")
            REFERENCES "DimGeography" ("GeographyKey");

ALTER TABLE "FactCallCenter"
    ADD CONSTRAINT "FK_FactCallCenter_DimDate"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactCurrencyRate"
    ADD CONSTRAINT "FK_FactCurrencyRate_DimCurrency"
        FOREIGN KEY ("CurrencyKey")
            REFERENCES "DimCurrency" ("CurrencyKey");

ALTER TABLE "FactCurrencyRate"
    ADD CONSTRAINT "FK_FactCurrencyRate_DimDate"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactFinance"
    ADD CONSTRAINT "FK_FactFinance_DimAccount"
        FOREIGN KEY ("AccountKey")
            REFERENCES "DimAccount" ("AccountKey");

ALTER TABLE "FactFinance"
    ADD CONSTRAINT "FK_FactFinance_DimDate"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactFinance"
    ADD CONSTRAINT "FK_FactFinance_DimDepartmentGroup"
        FOREIGN KEY ("DepartmentGroupKey")
            REFERENCES "DimDepartmentGroup" ("DepartmentGroupKey");

ALTER TABLE "FactFinance"
    ADD CONSTRAINT "FK_FactFinance_DimOrganization"
        FOREIGN KEY ("OrganizationKey")
            REFERENCES "DimOrganization" ("OrganizationKey");

ALTER TABLE "FactFinance"
    ADD CONSTRAINT "FK_FactFinance_DimScenario"
        FOREIGN KEY ("ScenarioKey")
            REFERENCES "DimScenario" ("ScenarioKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimCurrency"
        FOREIGN KEY ("CurrencyKey")
            REFERENCES "DimCurrency" ("CurrencyKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimCustomer"
        FOREIGN KEY ("CustomerKey")
            REFERENCES "DimCustomer" ("CustomerKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimDate"
        FOREIGN KEY ("OrderDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimDate1"
        FOREIGN KEY ("DueDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimDate2"
        FOREIGN KEY ("ShipDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimProduct"
        FOREIGN KEY ("ProductKey")
            REFERENCES "DimProduct" ("ProductKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimPromotion"
        FOREIGN KEY ("PromotionKey")
            REFERENCES "DimPromotion" ("PromotionKey");

ALTER TABLE "FactInternetSales"
    ADD CONSTRAINT "FK_FactInternetSales_DimSalesTerritory"
        FOREIGN KEY ("SalesTerritoryKey")
            REFERENCES "DimSalesTerritory" ("SalesTerritoryKey");

ALTER TABLE "FactInternetSalesReason"
    ADD CONSTRAINT "FK_FactInternetSalesReason_DimSalesReason"
        FOREIGN KEY ("SalesReasonKey")
            REFERENCES "DimSalesReason" ("SalesReasonKey");

ALTER TABLE "FactInternetSalesReason"
    ADD CONSTRAINT "FK_FactInternetSalesReason_FactInternetSales"
        FOREIGN KEY ("SalesOrderNumber", "SalesOrderLineNumber")
            REFERENCES "FactInternetSales" ("SalesOrderNumber", "SalesOrderLineNumber");

ALTER TABLE "FactProductInventory"
    ADD CONSTRAINT "FK_FactProductInventory_DimDate"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactProductInventory"
    ADD CONSTRAINT "FK_FactProductInventory_DimProduct"
        FOREIGN KEY ("ProductKey")
            REFERENCES "DimProduct" ("ProductKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimCurrency"
        FOREIGN KEY ("CurrencyKey")
            REFERENCES "DimCurrency" ("CurrencyKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimDate"
        FOREIGN KEY ("OrderDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimDate1"
        FOREIGN KEY ("DueDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimDate2"
        FOREIGN KEY ("ShipDateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimEmployee"
        FOREIGN KEY ("EmployeeKey")
            REFERENCES "DimEmployee" ("EmployeeKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimProduct"
        FOREIGN KEY ("ProductKey")
            REFERENCES "DimProduct" ("ProductKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimPromotion"
        FOREIGN KEY ("PromotionKey")
            REFERENCES "DimPromotion" ("PromotionKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimReseller"
        FOREIGN KEY ("ResellerKey")
            REFERENCES "DimReseller" ("ResellerKey");

ALTER TABLE "FactResellerSales"
    ADD CONSTRAINT "FK_FactResellerSales_DimSalesTerritory"
        FOREIGN KEY ("SalesTerritoryKey")
            REFERENCES "DimSalesTerritory" ("SalesTerritoryKey");

ALTER TABLE "FactSalesQuota"
    ADD CONSTRAINT "FK_FactSalesQuota_DimDate"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");

ALTER TABLE "FactSalesQuota"
    ADD CONSTRAINT "FK_FactSalesQuota_DimEmployee"
        FOREIGN KEY ("EmployeeKey")
            REFERENCES "DimEmployee" ("EmployeeKey");

ALTER TABLE "FactSurveyResponse"
    ADD CONSTRAINT "FK_FactSurveyResponse_CustomerKey"
        FOREIGN KEY ("CustomerKey")
            REFERENCES "DimCustomer" ("CustomerKey");

ALTER TABLE "FactSurveyResponse"
    ADD CONSTRAINT "FK_FactSurveyResponse_DateKey"
        FOREIGN KEY ("DateKey")
            REFERENCES "DimDate" ("DateKey");


-- ****************************************
-- Create View
-- ****************************************
CREATE VIEW "vDMPrep" AS
SELECT pc."EnglishProductCategoryName",
       COALESCE(p."ModelName", p."EnglishProductName") AS "Model",
       c."CustomerKey",
       s."SalesTerritoryGroup"                         AS "Region",
       CASE
           WHEN EXTRACT(MONTH FROM CURRENT_DATE) < EXTRACT(MONTH FROM c."BirthDate")
               THEN DATE_PART('YEAR', AGE(c."BirthDate", CURRENT_DATE)) - 1
           WHEN EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM c."BirthDate") AND
                EXTRACT(DAY FROM CURRENT_DATE) < EXTRACT(DAY FROM c."BirthDate")
               THEN DATE_PART('YEAR', AGE(c."BirthDate", CURRENT_DATE)) - 1
           ELSE DATE_PART('YEAR', AGE(c."BirthDate", CURRENT_DATE))
           END                                         AS "Age",
       CASE
           WHEN c."YearlyIncome"::numeric < 40000 THEN 'Low'
           WHEN c."YearlyIncome"::numeric > 60000 THEN 'High'
           ELSE 'Moderate'
           END                                         AS "IncomeGroup",
       d."CalendarYear",
       d."FiscalYear",
       d."MonthNumberOfYear"                           AS "Month",
       f."SalesOrderNumber"                            AS "OrderNumber",
       f."SalesOrderLineNumber"                        AS "LineNumber",
       f."OrderQuantity"                               AS "Quantity",
       f."ExtendedAmount"                              AS "Amount"
FROM "FactInternetSales" f
         INNER JOIN "DimDate" d ON f."OrderDateKey" = d."DateKey"
         INNER JOIN "DimProduct" p ON f."ProductKey" = p."ProductKey"
         INNER JOIN "DimProductSubcategory" psc ON p."ProductSubcategoryKey" = psc."ProductSubcategoryKey"
         INNER JOIN "DimProductCategory" pc ON psc."ProductCategoryKey" = pc."ProductCategoryKey"
         INNER JOIN "DimCustomer" c ON f."CustomerKey" = c."CustomerKey"
         INNER JOIN "DimGeography" g ON c."GeographyKey" = g."GeographyKey"
         INNER JOIN "DimSalesTerritory" s ON g."SalesTerritoryKey" = s."SalesTerritoryKey";


CREATE VIEW "vTimeSeries" AS
SELECT CASE "Model"
           WHEN 'Mountain-100' THEN 'M200'
           WHEN 'Road-150' THEN 'R250'
           WHEN 'Road-650' THEN 'R750'
           WHEN 'Touring-1000' THEN 'T1000'
           ELSE LEFT("Model", 1) || RIGHT("Model", 3)
           END || ' ' || "Region"                         AS "ModelRegion",

       ("CalendarYear"::integer * 100) + "Month"::integer AS "TimeIndex",

       SUM("Quantity")                                    AS "Quantity",
       SUM("Amount")                                      AS "Amount",
       "CalendarYear",
       "Month",
       "udfBuildISO8601Date"("CalendarYear", "Month", 25) AS "ReportingDate"
FROM "vDMPrep"
WHERE "Model" IN ('Mountain-100', 'Mountain-200',
                  'Road-150', 'Road-250',
                  'Road-650', 'Road-750', 'Touring-1000')
GROUP BY 1, 2,
         "CalendarYear",
         "Month",
         "udfBuildISO8601Date"("CalendarYear", "Month", 25);


CREATE VIEW "vTargetMail" AS
SELECT c."CustomerKey",
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
FROM "DimCustomer" c
         INNER JOIN (SELECT "CustomerKey",
                            "Region",
                            "Age",
                            SUM(
                                    CASE
                                        WHEN "EnglishProductCategoryName" = 'Bikes' THEN 1
                                        ELSE 0
                                        END
                            ) AS "Bikes"
                     FROM "vDMPrep"
                     GROUP BY "CustomerKey",
                              "Region",
                              "Age") x
                    ON c."CustomerKey" = x."CustomerKey";

CREATE VIEW "vAssocSeqOrders"
AS
SELECT DISTINCT "OrderNumber", "CustomerKey", "Region", "IncomeGroup"
FROM "vDMPrep"
WHERE ("FiscalYear" = '2013');

CREATE VIEW "vAssocSeqLineItems"
AS
SELECT "OrderNumber", "LineNumber", "Model"
FROM "vDMPrep"
WHERE ("FiscalYear" = '2013');


\copy "DimAccount"                                           FROM './dbo_DimAccount_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimCurrency"                                          FROM './dbo_DimCurrency_202309251159.csv' DELIMITER E',' CSV HEADER;

\copy "DimSalesTerritory"                                    FROM './dbo_DimSalesTerritory_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimGeography"                                         FROM './dbo_DimGeography_202309251159.csv' DELIMITER E',' CSV HEADER;

\copy "DimCustomer"                                          FROM './dbo_DimCustomer_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimDate"                                              FROM './dbo_DimDate_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimDepartmentGroup"                                   FROM './dbo_DimDepartmentGroup_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimEmployee"                                          FROM './dbo_DimEmployee_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimOrganization"                                      FROM './dbo_DimOrganization_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimProduct"                                           FROM './dbo_DimProduct_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimProductCategory"                                   FROM './dbo_DimProductCategory_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimProductSubcategory"                                FROM './dbo_DimProductSubcategory_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimPromotion"                                         FROM './dbo_DimPromotion_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimReseller"                                          FROM './dbo_DimReseller_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimSalesReason"                                       FROM './dbo_DimSalesReason_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "DimScenario"                                          FROM './dbo_DimScenario_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactAdditionalInternationalProductDescription"        FROM './dbo_FactAdditionalInternationalProductDescription_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactCallCenter"                                       FROM './dbo_FactCallCenter_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactCurrencyRate"                                     FROM './dbo_FactCurrencyRate_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactFinance"                                          FROM './dbo_FactFinance_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactInternetSales"                                    FROM './dbo_FactInternetSales_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactInternetSalesReason"                              FROM './dbo_FactInternetSalesReason_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactProductInventory"                                 FROM './dbo_FactProductInventory_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactResellerSales"                                    FROM './dbo_FactResellerSales_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactSalesQuota"                                       FROM './dbo_FactSalesQuota_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "FactSurveyResponse"                                   FROM './dbo_FactSurveyResponse_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "NewFactCurrencyRate"                                  FROM './dbo_NewFactCurrencyRate_202309251159.csv' DELIMITER E',' CSV HEADER;
\copy "ProspectiveBuyer"                                     FROM './dbo_ProspectiveBuyer_202309251159.csv' DELIMITER E',' CSV HEADER;