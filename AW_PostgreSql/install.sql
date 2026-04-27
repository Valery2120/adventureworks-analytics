-- AdventureWorks Raw Ingestion Script
-- Standardized for Comma-Separated Files (UTF-8)
-- Optimized for further dbt transformations

-- 1. GLOBAL SETTINGS
\set client_encoding 'UTF8';
SET client_encoding = 'UTF8';

-- Enable UUID support (required for the uuid data type)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. SCHEMAS
CREATE SCHEMA IF NOT EXISTS person;
CREATE SCHEMA IF NOT EXISTS humanresources;
CREATE SCHEMA IF NOT EXISTS production;
CREATE SCHEMA IF NOT EXISTS purchasing;
CREATE SCHEMA IF NOT EXISTS sales;

--------------------------------------------------------
-- 3. SCHEMA: PERSON
--------------------------------------------------------

CREATE TABLE person.businessentity (
    businessentityid int PRIMARY KEY,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.person (
    businessentityid int PRIMARY KEY,
    persontype char(2),
    namestyle boolean,
    title varchar(8),
    firstname varchar(50),
    middlename varchar(50),
    lastname varchar(50),
    suffix varchar(10),
    emailpromotion int,
    additionalcontactinfo xml,
    demographics xml,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.address (
    addressid int PRIMARY KEY,
    addressline1 varchar(60),
    addressline2 varchar(60),
    city varchar(30),
    stateprovinceid int,
    postalcode varchar(15),
    spatiallocation bytea,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.addresstype (
    addresstypeid int PRIMARY KEY,
    name varchar(50),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.businessentityaddress (
    businessentityid int,
    addressid int,
    addresstypeid int,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, addressid, addresstypeid)
);

CREATE TABLE person.contacttype (
    contacttypeid int PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE person.businessentitycontact (
    businessentityid int,
    personid int,
    contacttypeid int,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, personid, contacttypeid)
);

CREATE TABLE person.emailaddress (
    businessentityid int,
    emailaddressid int,
    emailaddress varchar(50),
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, emailaddressid)
);

CREATE TABLE person.password (
    businessentityid int PRIMARY KEY,
    passwordhash varchar(128),
    passwordsalt varchar(10),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.phonenumbertype (
    phonenumbertypeid int PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE person.personphone (
    businessentityid int,
    phonenumber varchar(25),
    phonenumbertypeid int,
    modifieddate timestamp, 
    PRIMARY KEY(businessentityid, phonenumber, phonenumbertypeid)
);

CREATE TABLE person.stateprovince (
    stateprovinceid int PRIMARY KEY,
    stateprovincecode char(3),
    countryregioncode varchar(3),
    isonlystateprovinceflag boolean,
    name varchar(50),
    territoryid int,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE person.countryregion (
    countryregioncode varchar(3) PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

--------------------------------------------------------
-- 4. SCHEMA: HUMANRESOURCE
--------------------------------------------------------

CREATE TABLE humanresources.department (
    departmentid int PRIMARY KEY,
    name varchar(50),
    groupname varchar(50),
    modifieddate timestamp
);

CREATE TABLE humanresources.employee (
    businessentityid int PRIMARY KEY,
    nationalidnumber varchar(15),
    loginid varchar(256),
    organizationnode varchar,  
    organizationlevel int,
    jobtitle varchar(50),
    birthdate date,
    maritalstatus char(1),
    gender char(1),
    hiredate date,
    salariedflag boolean,
    vacationhours smallint,
    sickleavehours smallint,
    currentflag boolean,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE humanresources.employeedepartmenthistory (
    businessentityid int,
    departmentid smallint,
    shiftid smallint,
    startdate date,
    enddate date,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, departmentid, shiftid, startdate)
);

CREATE TABLE humanresources.employeepayhistory (
    businessentityid int,
    ratechangedate timestamp,
    rate numeric,
    payfrequency smallint,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, ratechangedate)
);

CREATE TABLE humanresources.jobcandidate (
    jobcandidateid int PRIMARY KEY,
    businessentityid int,
    resume xml,
    modifieddate timestamp
);

CREATE TABLE humanresources.shift (
    shiftid int PRIMARY KEY,
    name varchar(50),
    starttime time,
    endtime time,
    modifieddate timestamp
);

--------------------------------------------------------
-- 5. SCHEMA: PRODUCTION
--------------------------------------------------------

CREATE TABLE production.productdescription (
    productdescriptionid int PRIMARY KEY,
    description text,            
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.document (
    documentnode varchar PRIMARY KEY,
    documentlevel int,
    title varchar(50),
    owner int,
    folderflag boolean,
    filename varchar(400),
    fileextension varchar(8),
    revision char(5),
    changenumber int,
    status smallint,
    documentsummary text,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.productmodel (
    productmodelid int PRIMARY KEY,
    name varchar(50),
    catalogdescription xml,
    instructions xml,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.productsubcategory (
    productsubcategoryid int PRIMARY KEY,
    productcategoryid int,
    name varchar(50),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.productcategory (
    productcategoryid int PRIMARY KEY,
    name varchar(50),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.product (
    productid int PRIMARY KEY,
    name varchar(50),
    productnumber varchar(25),
    makeflag boolean,
    finishedgoodsflag boolean,
    color varchar(15),
    safetystocklevel smallint,
    reorderpoint smallint,
    standardcost numeric,
    listprice numeric,
    size varchar(5),
    sizeunitmeasurecode char(3),
    weightunitmeasurecode char(3),
    weight decimal(8, 2),
    daystomanufacture int,
    productline char(2),
    class char(2),
    style char(2),
    productsubcategoryid int,
    productmodelid int,
    sellstartdate timestamp,
    sellenddate timestamp,
    discontinueddate timestamp,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE production.workorder (
    workorderid int PRIMARY KEY,
    productid int,
    orderqty int,
    stockedqty int,
    scrappedqty smallint,
    startdate timestamp,
    enddate timestamp,
    duedate timestamp,
    scrapreasonid smallint,
    modifieddate timestamp
);

CREATE TABLE production.billofmaterials (
    billofmaterialsid int PRIMARY KEY,
    productassemblyid int,
    componentid int,
    startdate timestamp,
    enddate timestamp,
    unitmeasurecode char(3),
    bomlevel smallint,
    perassemblyqty decimal(8, 2),
    modifieddate timestamp
);

CREATE TABLE production.productcosthistory (
    productid int,
    startdate timestamp,
    enddate timestamp,
    standardcost numeric,
    modifieddate timestamp,
    PRIMARY KEY (productid, startdate)
);

CREATE TABLE production.culture (
    cultureid char(6) PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE production.illustration (
    illustrationid int PRIMARY KEY,
    diagram text,
    modifieddate timestamp
);

CREATE TABLE production.location (
    locationid int PRIMARY KEY,
    name varchar(50),
    costrate numeric,
    availability decimal(8, 2),
    modifieddate timestamp
);

CREATE TABLE production.productinventory (
    productid int,
    locationid smallint,
    shelf varchar(10),
    bin smallint,
    quantity smallint,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(productid, locationid)
);

CREATE TABLE production.productphoto (
    productphotoid int PRIMARY KEY,
    thumbnailphotofilename varchar(50),
    largephotofilename varchar(50),
    modifieddate timestamp
);

CREATE TABLE production.productproductphoto (
    productid int,
    productphotoid int,
    "primary" boolean,
    modifieddate timestamp,
    PRIMARY KEY(productid, productphotoid)
);

CREATE TABLE production.productreview (
    productreviewid int PRIMARY KEY,
    productid int,
    reviewername varchar(50),
    reviewdate timestamp,
    emailaddress varchar(50),
    rating int,
    comments text,
    modifieddate timestamp
);

CREATE TABLE production.scrapreason (
    scrapreasonid int PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE production.unitmeasure (
    unitmeasurecode char(3) PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE production.workorderrouting (
    workorderid int,
    productid int,
    operationsequence smallint,
    locationid smallint,
    scheduledstartdate timestamp,
    scheduledenddate timestamp,
    actualstartdate timestamp,
    actualenddate timestamp,
    actualresourcehrs decimal(9, 4),
    plannedcost numeric,
    actualcost numeric,
    modifieddate timestamp,
    PRIMARY KEY(workorderid, productid, operationsequence)
);

CREATE TABLE production.productdocument (
    productid int,
    documentnode varchar, 
    modifieddate timestamp,
    PRIMARY KEY(productid, documentnode)
);

CREATE TABLE production.productlistpricehistory (
    productid int,
    startdate timestamp,
    enddate timestamp,
    listprice numeric,
    modifieddate timestamp,
    PRIMARY KEY(productid, startdate)
);

CREATE TABLE production.productmodelillustration (
    productmodelid int,
    illustrationid int,
    modifieddate timestamp,
    PRIMARY KEY(productmodelid, illustrationid)
);

CREATE TABLE production.productmodelproductdescriptionculture (
    productmodelid int,
    productdescriptionid int,
    cultureid char(6),
    modifieddate timestamp,
    PRIMARY KEY(productmodelid, productdescriptionid, cultureid)
);

CREATE TABLE production.transactionhistory (
    transactionid int PRIMARY KEY,
    productid int,
    referenceorderid int,
    referenceorderlineid int,
    transactiondate timestamp,
    transactiontype char(1),
    quantity int,
    actualcost numeric,
    modifieddate timestamp
);

CREATE TABLE production.transactionhistoryarchive (
    transactionid int PRIMARY KEY,
    productid int,
    referenceorderid int,
    referenceorderlineid int,
    transactiondate timestamp,
    transactiontype char(1),
    quantity int,
    actualcost numeric,
    modifieddate timestamp
);

--------------------------------------------------------
-- 6. SCHEMA: PURCHASING
--------------------------------------------------------

CREATE TABLE purchasing.vendor (
    businessentityid int PRIMARY KEY,
    accountnumber varchar(15),
    name varchar(50),
    creditrating smallint,
    preferredvendorstatus boolean,
    activeflag boolean,
    purchasingwebserviceurl varchar(1024),
    modifieddate timestamp
);

CREATE TABLE purchasing.shipmethod (
    shipmethodid int PRIMARY KEY,
    name varchar(50),
    shipbase numeric,
    shiprate numeric,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE purchasing.productvendor (
    productid int,
    businessentityid int,
    averageleadtime int,
    standardprice numeric,
    lastreceiptcost numeric,
    lastreceiptdate timestamp,
    minorderqty int,
    maxorderqty int,
    onorderqty int,
    unitmeasurecode char(3),
    modifieddate timestamp,
    PRIMARY KEY(productid, businessentityid)
);

CREATE TABLE purchasing.purchaseorderheader (
    purchaseorderid int PRIMARY KEY,
    revisionnumber smallint,
    status smallint,
    employeeid int,
    vendorid int,
    shipmethodid int,
    orderdate timestamp,
    shipdate timestamp,
    subtotal numeric,
    taxamt numeric,
    freight numeric,
    totaldue numeric, 
    modifieddate timestamp
);

CREATE TABLE purchasing.purchaseorderdetail (
    purchaseorderid int,
    purchaseorderdetailid int,
    duedate timestamp,
    orderqty smallint,
    productid int,
    unitprice numeric,
    linetotal numeric, 
    receivedqty decimal(8, 2),
    rejectedqty decimal(8, 2),
    stockedqty numeric,
    modifieddate timestamp,
    PRIMARY KEY(purchaseorderid, purchaseorderdetailid)
);

--------------------------------------------------------
-- 7. SCHEMA: SALES
--------------------------------------------------------

CREATE TABLE sales.salesterritory (
    territoryid int PRIMARY KEY,
    name varchar(50),
    countryregioncode varchar(3),
    "group" varchar(50),  
    salesytd numeric,
    saleslastyear numeric,
    costytd numeric,
    costlastyear numeric,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.salesperson (
    businessentityid int PRIMARY KEY,
    territoryid int,
    salesquota numeric,
    bonus numeric,
    commissionpct numeric,
    salesytd numeric,
    saleslastyear numeric,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.salespersonquotahistory (
    businessentityid int,
    quotadate timestamp,
    salesquota numeric,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, quotadate)
);

CREATE TABLE sales.salesreason (
    salesreasonid int PRIMARY KEY,
    name varchar(50),
    reasontype varchar(50),
    modifieddate timestamp
);

CREATE TABLE sales.salesorderheader (
    salesorderid int PRIMARY KEY,
    revisionnumber smallint,
    orderdate timestamp,
    duedate timestamp,
    shipdate timestamp,
    status smallint,
    onlineorderflag boolean,
    salesordernumber varchar(23), 
    purchaseordernumber varchar(25),
    accountnumber varchar(15),
    customerid int,
    salespersonid int,
    territoryid int,
    billtoaddressid int,
    shiptoaddressid int,
    shipmethodid int,
    creditcardid int,
    creditcardapprovalcode varchar(15),
    currencyrateid int,
    subtotal numeric,
    taxamt numeric,
    freight numeric,
    totaldue numeric,            
    comment varchar(128),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.salesorderdetail (
    salesorderid int,
    salesorderdetailid int,
    carriertrackingnumber varchar(25),
    orderqty smallint,
    productid int,
    specialofferid int,
    unitprice numeric,
    unitpricediscount numeric,
    linetotal numeric,           
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(salesorderid, salesorderdetailid)
);

CREATE TABLE sales.specialoffer (
    specialofferid int PRIMARY KEY,
    description varchar(255),
    discountpct numeric,
    type varchar(50),
    category varchar(50),
    startdate timestamp,
    enddate timestamp,
    minqty int,
    maxqty int,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.specialofferproduct (
    specialofferid int,
    productid int,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(specialofferid, productid)
);

CREATE TABLE sales.customer (
    customerid int PRIMARY KEY,
    personid int,
    storeid int,
    territoryid int,
    accountnumber varchar(15),    
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.store (
    businessentityid int PRIMARY KEY,
    name varchar(50),
    salespersonid int,
    demographics xml,
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.creditcard (
    creditcardid int PRIMARY KEY,
    cardtype varchar(50),
    cardnumber varchar(25),
    expmonth smallint,
    expyear smallint,
    modifieddate timestamp
);

CREATE TABLE sales.personcreditcard (
    businessentityid int,
    creditcardid int,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, creditcardid)
);

CREATE TABLE sales.currency (
    currencycode char(3) PRIMARY KEY,
    name varchar(50),
    modifieddate timestamp
);

CREATE TABLE sales.currencyrate (
    currencyrateid int PRIMARY KEY,
    currencyratedate timestamp,
    fromcurrencycode char(3),
    tocurrencycode char(3),
    averagerate numeric,
    endofdayrate numeric,
    modifieddate timestamp
);

CREATE TABLE sales.countryregioncurrency (
    countryregioncode varchar(3),
    currencycode char(3),
    modifieddate timestamp,
    PRIMARY KEY(countryregioncode, currencycode)
);

CREATE TABLE sales.shoppingcartitem (
    shoppingcartitemid int PRIMARY KEY,
    shoppingcartid varchar(50),
    quantity int,
    productid int,
    datecreated timestamp,
    modifieddate timestamp
);

CREATE TABLE sales.salestaxrate (
    salestaxrateid int PRIMARY KEY,
    stateprovinceid int,
    taxtype smallint,
    taxrate numeric,
    name varchar(50),
    rowguid uuid,
    modifieddate timestamp
);

CREATE TABLE sales.salesterritoryhistory (
    businessentityid int,
    territoryid int,
    startdate timestamp,
    enddate timestamp,
    rowguid uuid,
    modifieddate timestamp,
    PRIMARY KEY(businessentityid, territoryid, startdate)
);

CREATE TABLE sales.salesorderheadersalesreason (
    salesorderid int,
    salesreasonid int,
    modifieddate timestamp,
    PRIMARY KEY(salesorderid, salesreasonid)
);

--------------------------------------------------------
-- 8. DATA INGESTION
--------------------------------------------------------

-- Ensure the client is ready for UTF-8 data
\set client_encoding 'UTF8';

-- PERSON SCHEMA
SELECT 'Loading Person schema...';
\copy person.address FROM 'Person Address.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.addresstype FROM 'Person AddressType.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.businessentity FROM 'Person BusinessEntity.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.businessentityaddress FROM 'Person BusinessEntityAddress.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.businessentitycontact FROM 'Person BusinessEntityContact.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.contacttype FROM 'Person ContactType.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.countryregion FROM 'Person CountryRegion.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.emailaddress FROM 'Person EmailAddress.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.password FROM 'Person Password.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.person FROM 'Person Person.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.personphone FROM 'Person PersonPhone.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.phonenumbertype FROM 'Person PhoneNumberType.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy person.stateprovince FROM 'Person StateProvince.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

-- HUMAN RESOURCES SCHEMA
SELECT 'Loading HumanResources schema...';
\copy humanresources.department FROM 'HumanResources Department.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy humanresources.employee FROM 'HumanResources Employee.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy humanresources.employeedepartmenthistory FROM 'HumanResources EmployeeDepartmentHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy humanresources.employeepayhistory FROM 'HumanResources EmployeePayHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy humanresources.jobcandidate FROM 'HumanResources JobCandidate.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy humanresources.shift FROM 'HumanResources Shift.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

-- PRODUCTION SCHEMA
SELECT 'Loading Production schema...';
\copy production.billofmaterials FROM 'Production BillOfMaterials.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.culture FROM 'Production Culture.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.document FROM 'Production Document.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.illustration FROM 'Production Illustration.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.location FROM 'Production Location.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.product FROM 'Production Product.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productcategory FROM 'Production ProductCategory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productcosthistory FROM 'Production ProductCostHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productdescription FROM 'Production ProductDescription.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productdocument FROM 'Production ProductDocument.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productinventory FROM 'Production ProductInventory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productlistpricehistory FROM 'Production ProductListPriceHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productmodel FROM 'Production ProductModel.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productmodelillustration FROM 'Production ProductModelIllustration.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productmodelproductdescriptionculture FROM 'Production ProductModelProductDescriptionCulture.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productphoto FROM 'Production ProductPhoto.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productproductphoto FROM 'Production ProductProductPhoto.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productreview FROM 'Production ProductReview.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.productsubcategory FROM 'Production ProductSubcategory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.scrapreason FROM 'Production ScrapReason.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.transactionhistory FROM 'Production TransactionHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.transactionhistoryarchive FROM 'Production TransactionHistoryArchive.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.unitmeasure FROM 'Production UnitMeasure.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.workorder FROM 'Production WorkOrder.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy production.workorderrouting FROM 'Production WorkOrderRouting.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

-- PURCHASING SCHEMA
SELECT 'Loading Purchasing schema...';
\copy purchasing.productvendor FROM 'Purchasing ProductVendor.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy purchasing.purchaseorderdetail FROM 'Purchasing PurchaseOrderDetail.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy purchasing.purchaseorderheader FROM 'Purchasing PurchaseOrderHeader.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy purchasing.shipmethod FROM 'Purchasing ShipMethod.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy purchasing.vendor FROM 'Purchasing Vendor.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

-- SALES SCHEMA
SELECT 'Loading Sales schema...';
\copy sales.countryregioncurrency FROM 'Sales CountryRegionCurrency.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.creditcard FROM 'Sales CreditCard.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.currency FROM 'Sales Currency.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.currencyrate FROM 'Sales CurrencyRate.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.customer FROM 'Sales Customer.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.personcreditcard FROM 'Sales PersonCreditCard.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesorderdetail FROM 'Sales SalesOrderDetail.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesorderheader FROM 'Sales SalesOrderHeader.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesorderheadersalesreason FROM 'Sales SalesOrderHeaderSalesReason.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesperson FROM 'Sales SalesPerson.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salespersonquotahistory FROM 'Sales SalesPersonQuotaHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesreason FROM 'Sales SalesReason.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salestaxrate FROM 'Sales SalesTaxRate.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesterritory FROM 'Sales SalesTerritory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.salesterritoryhistory FROM 'Sales SalesTerritoryHistory.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.shoppingcartitem FROM 'Sales ShoppingCartItem.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.specialoffer FROM 'Sales SpecialOffer.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.specialofferproduct FROM 'Sales SpecialOfferProduct.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);
\copy sales.store FROM 'Sales Store.csv' WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

-- Очищаем коды размеров
UPDATE production.product 
SET sizeunitmeasurecode = NULL 
WHERE TRIM(sizeunitmeasurecode) = '';

-- Очищаем коды веса
UPDATE production.product 
SET weightunitmeasurecode = NULL 
WHERE TRIM(weightunitmeasurecode) = '';

-- ADD FOREIGN KEYS FOR PERSON SCHEMA
ALTER TABLE person.address ADD CONSTRAINT fk_address_state FOREIGN KEY (stateprovinceid) REFERENCES person.stateprovince(stateprovinceid);

ALTER TABLE person.stateprovince ADD CONSTRAINT fk_state_country FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);
ALTER TABLE person.stateprovince ADD CONSTRAINT fk_state_salter FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);

ALTER TABLE person.person ADD CONSTRAINT fk_person_be FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);

ALTER TABLE person.businessentityaddress ADD CONSTRAINT fk_busentadr_adr FOREIGN KEY (addressid) REFERENCES person.address(addressid);
ALTER TABLE person.businessentityaddress ADD CONSTRAINT fk_busentadr_adrtype FOREIGN KEY (addresstypeid) REFERENCES person.addresstype(addresstypeid);
ALTER TABLE person.businessentityaddress ADD CONSTRAINT fk_busentadr_be FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);

ALTER TABLE person.businessentitycontact ADD CONSTRAINT fk_busentcont_pers FOREIGN KEY (personid) REFERENCES person.person(businessentityid);
ALTER TABLE person.businessentitycontact ADD CONSTRAINT fk_busentcont_contype FOREIGN KEY (contacttypeid) REFERENCES person.contacttype(contacttypeid);
ALTER TABLE person.businessentitycontact ADD CONSTRAINT fk_busentcont_busent FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);

ALTER TABLE person.emailaddress ADD CONSTRAINT fk_email_pers FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);

ALTER TABLE person.password ADD CONSTRAINT fk_password_pers FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);

ALTER TABLE person.personphone ADD CONSTRAINT fk_phone_pers FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);
ALTER TABLE person.personphone ADD CONSTRAINT fk_phone_phntype FOREIGN KEY (phonenumbertypeid) REFERENCES person.phonenumbertype(phonenumbertypeid);

-- ADD FOREIGN KEYS FOR HUMANRESOURCES SCHEMA
ALTER TABLE humanresources.employee ADD CONSTRAINT fk_emp_person FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);
ALTER TABLE humanresources.employeedepartmenthistory ADD CONSTRAINT fk_edh_emp FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);
ALTER TABLE humanresources.employeedepartmenthistory ADD CONSTRAINT fk_edh_dept FOREIGN KEY (departmentid) REFERENCES humanresources.department(departmentid);
ALTER TABLE humanresources.employeedepartmenthistory ADD CONSTRAINT fk_edh_shift FOREIGN KEY (shiftid) REFERENCES humanresources.shift(shiftid);

ALTER TABLE humanresources.employeepayhistory ADD CONSTRAINT fk_eph_emp FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);

ALTER TABLE humanresources.jobcandidate ADD CONSTRAINT fk_jobcand_emp FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);

-- ADD FOREIGN KEYS FOR PRODUCTION SCHEMA
ALTER TABLE production.billofmaterials ADD CONSTRAINT fk_bill_prod_assemb FOREIGN KEY (productassemblyid) REFERENCES production.product(productid);
ALTER TABLE production.billofmaterials ADD CONSTRAINT fk_bill_prod_comp FOREIGN KEY (componentid) REFERENCES production.product(productid);
ALTER TABLE production.billofmaterials ADD CONSTRAINT fk_bill_prod FOREIGN KEY (unitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);

ALTER TABLE production.product ADD CONSTRAINT fk_prod_model FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);
ALTER TABLE production.product ADD CONSTRAINT fk_prod_subcat FOREIGN KEY (productsubcategoryid) REFERENCES production.productsubcategory(productsubcategoryid);
ALTER TABLE production.product ADD CONSTRAINT fk_prod_sizeumeas FOREIGN KEY (sizeunitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);
ALTER TABLE production.product ADD CONSTRAINT fk_prod_weightumeas FOREIGN KEY (weightunitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);

ALTER TABLE production.productsubcategory ADD CONSTRAINT fk_subcat_cat FOREIGN KEY (productcategoryid) REFERENCES production.productcategory(productcategoryid);

ALTER TABLE production.productinventory ADD CONSTRAINT fk_inv_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE production.productinventory ADD CONSTRAINT fk_inv_loc FOREIGN KEY (locationid) REFERENCES production.location(locationid);

ALTER TABLE production.document ADD CONSTRAINT fk_doc_emp FOREIGN KEY (owner) REFERENCES humanresources.employee(businessentityid);

ALTER TABLE production.productcosthistory ADD CONSTRAINT fk_prodcosthis_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE production.productdocument ADD CONSTRAINT fk_proddoc_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE production.productdocument ADD CONSTRAINT fk_proddoc_doc FOREIGN KEY (documentnode) REFERENCES production.document(documentnode);

ALTER TABLE production.productlistpricehistory ADD CONSTRAINT fk_pricehis_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE production.productmodelillustration ADD CONSTRAINT fk_modpic_mod FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);
ALTER TABLE production.productmodelillustration ADD CONSTRAINT fk_modpic_pic FOREIGN KEY (illustrationid) REFERENCES production.illustration(illustrationid);

ALTER TABLE production.productmodelproductdescriptionculture ADD CONSTRAINT fk_proddescculture_proddesc FOREIGN KEY (productdescriptionid) REFERENCES production.productdescription(productdescriptionid);
ALTER TABLE production.productmodelproductdescriptionculture ADD CONSTRAINT fk_proddescculture_prodculture FOREIGN KEY (cultureid) REFERENCES production.culture(cultureid);
ALTER TABLE production.productmodelproductdescriptionculture ADD CONSTRAINT fk_proddescculture_model FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);

ALTER TABLE production.productproductphoto ADD CONSTRAINT fk_prodphoto_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE production.productproductphoto ADD CONSTRAINT fk_prodphoto_photo FOREIGN KEY (productphotoid) REFERENCES production.productphoto(productphotoid);

ALTER TABLE production.productreview ADD CONSTRAINT fk_prodreview_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE production.transactionhistory ADD CONSTRAINT fk_tranhis_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE production.workorder ADD CONSTRAINT fk_workorder_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE production.workorder ADD CONSTRAINT fk_workorder_screason FOREIGN KEY (scrapreasonid) REFERENCES production.scrapreason(scrapreasonid);

ALTER TABLE production.workorderrouting ADD CONSTRAINT fk_wor_loc FOREIGN KEY (locationid) REFERENCES production.location(locationid);
ALTER TABLE production.workorderrouting ADD CONSTRAINT fk_wor_worder FOREIGN KEY (workorderid) REFERENCES production.workorder(workorderid);

-- ADD FOREIGN KEYS FOR PURCHASING SCHEMA
ALTER TABLE purchasing.purchaseorderheader ADD CONSTRAINT fk_poh_vendor FOREIGN KEY (vendorid) REFERENCES purchasing.vendor(businessentityid);
ALTER TABLE purchasing.purchaseorderheader ADD CONSTRAINT fk_poh_ship FOREIGN KEY (shipmethodid) REFERENCES purchasing.shipmethod(shipmethodid);
ALTER TABLE purchasing.purchaseorderheader ADD CONSTRAINT fk_poh_emp FOREIGN KEY (employeeid) REFERENCES humanresources.employee(businessentityid);

ALTER TABLE purchasing.purchaseorderdetail ADD CONSTRAINT fk_pod_poh FOREIGN KEY (purchaseorderid) REFERENCES purchasing.purchaseorderheader(purchaseorderid);
ALTER TABLE purchasing.purchaseorderdetail ADD CONSTRAINT fk_pod_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE purchasing.productvendor ADD CONSTRAINT fk_prodvendor_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE purchasing.productvendor ADD CONSTRAINT fk_prodvendor_umeasure FOREIGN KEY (unitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);
ALTER TABLE purchasing.productvendor ADD CONSTRAINT fk_prodvendor_vendor FOREIGN KEY (businessentityid) REFERENCES purchasing.vendor(businessentityid);

ALTER TABLE purchasing.vendor ADD CONSTRAINT fk_vendor_entitye FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);

-- ADD FOREIGN KEYS FOR SALES SCHEMA
ALTER TABLE sales.customer ADD CONSTRAINT fk_customer_person FOREIGN KEY (personid) REFERENCES person.person(businessentityid);
ALTER TABLE sales.customer ADD CONSTRAINT fk_customer_store FOREIGN KEY (storeid) REFERENCES sales.store(businessentityid);
ALTER TABLE sales.customer ADD CONSTRAINT fk_customer_territory FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);

ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_cust FOREIGN KEY (customerid) REFERENCES sales.customer(customerid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_territory FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_customer FOREIGN KEY (customerid) REFERENCES sales.customer(customerid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_salesperson FOREIGN KEY (salespersonid) REFERENCES sales.salesperson(businessentityid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_currencyrate FOREIGN KEY (currencyrateid) REFERENCES sales.currencyrate(currencyrateid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_billto_addr FOREIGN KEY (billtoaddressid) REFERENCES person.address(addressid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_shipto_addr FOREIGN KEY (shiptoaddressid) REFERENCES person.address(addressid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_credcard FOREIGN KEY (creditcardid) REFERENCES sales.creditcard(creditcardid);
ALTER TABLE sales.salesorderheader ADD CONSTRAINT fk_soh_shmethod FOREIGN KEY (shipmethodid) REFERENCES purchasing.shipmethod(shipmethodid);

ALTER TABLE sales.salesorderheadersalesreason ADD CONSTRAINT fk_sohsr_credcard FOREIGN KEY (salesreasonid) REFERENCES sales.salesreason(salesreasonid);
ALTER TABLE sales.salesorderheadersalesreason ADD CONSTRAINT fk_sohsr_soh FOREIGN KEY (salesorderid) REFERENCES sales.salesorderheader(salesorderid);

ALTER TABLE sales.salesorderdetail ADD CONSTRAINT fk_sod_soh FOREIGN KEY (salesorderid) REFERENCES sales.salesorderheader(salesorderid) ON DELETE CASCADE;
ALTER TABLE sales.salesorderdetail ADD CONSTRAINT fk_sod_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE sales.salesorderdetail ADD CONSTRAINT fk_sod_soprod FOREIGN KEY (specialofferid, productid) REFERENCES sales.specialofferproduct(specialofferid, productid);


ALTER TABLE sales.salesperson ADD CONSTRAINT fk_salesperson_be FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);
ALTER TABLE sales.salesperson ADD CONSTRAINT fk_salesperson_territory FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);

ALTER TABLE sales.salestaxrate ADD CONSTRAINT fk_taxrate_state FOREIGN KEY (stateprovinceid) REFERENCES person.stateprovince(stateprovinceid);

ALTER TABLE sales.countryregioncurrency ADD CONSTRAINT fk_crc_country FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);
ALTER TABLE sales.countryregioncurrency ADD CONSTRAINT fk_crc_currency FOREIGN KEY (currencycode) REFERENCES sales.currency(currencycode);

ALTER TABLE sales.currencyrate ADD CONSTRAINT fk_currate_from_currency FOREIGN KEY (fromcurrencycode) REFERENCES sales.currency(currencycode);
ALTER TABLE sales.currencyrate ADD CONSTRAINT fk_currate_to_currency FOREIGN KEY (tocurrencycode) REFERENCES sales.currency(currencycode);

ALTER TABLE sales.personcreditcard ADD CONSTRAINT fk_percard_pers FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);
ALTER TABLE sales.personcreditcard ADD CONSTRAINT fk_percard_card FOREIGN KEY (creditcardid) REFERENCES sales.creditcard(creditcardid);

ALTER TABLE sales.salespersonquotahistory ADD CONSTRAINT fk_spqh_salesperson FOREIGN KEY (businessentityid) REFERENCES sales.salesperson(businessentityid);

ALTER TABLE sales.salesterritory ADD CONSTRAINT fk_ter_region FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);

ALTER TABLE sales.salesterritoryhistory ADD CONSTRAINT fk_terhistory_region FOREIGN KEY (businessentityid) REFERENCES sales.salesperson(businessentityid);
ALTER TABLE sales.salesterritoryhistory ADD CONSTRAINT fk_terhistory_ter FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);

ALTER TABLE sales.shoppingcartitem ADD CONSTRAINT fk_sci_prod FOREIGN KEY (productid) REFERENCES production.product(productid);

ALTER TABLE sales.specialofferproduct ADD CONSTRAINT fk_scp_prod FOREIGN KEY (productid) REFERENCES production.product(productid);
ALTER TABLE sales.specialofferproduct ADD CONSTRAINT fk_scp_spoffer FOREIGN KEY (specialofferid) REFERENCES sales.specialoffer(specialofferid);

ALTER TABLE sales.store ADD CONSTRAINT fk_store_entity FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);
ALTER TABLE sales.store ADD CONSTRAINT fk_store_sper FOREIGN KEY (salespersonid) REFERENCES sales.salesperson(businessentityid);

SELECT 'Raw Ingestion Complete!';