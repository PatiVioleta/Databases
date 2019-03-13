
CREATE TABLE brochures(
	brochureID int PRIMARY KEY,
	startDate date NOT NULL,
	endDate date NOT NULL,
	);

CREATE TABLE pages(
	pageNumber int,
	brochureID int REFERENCES brochures(brochureID) NOT NULL,
	PRIMARY KEY (pageNumber, brochureID),
	);

CREATE TABLE productsDetails(
	productCode int PRIMARY KEY,
    productType varchar(20) NOT NULL,
	productFirm varchar(20) NOT NULL,
	productColor varchar(10),
	productDesc varchar(100),
	);

CREATE TABLE products(
	productCode int UNIQUE FOREIGN KEY REFERENCES productsDetails(productCode),
	brochureID int,
	PRIMARY KEY (productCode, brochureID),

	pageNumber int,
	FOREIGN KEY (pageNumber, brochureID) REFERENCES pages(pageNumber, brochureID),

	productName varchar(20) NOT NULL,
	productPrice real NOT NULL,
	);

CREATE TABLE customerDetails(
	customerID int PRIMARY KEY,
	customerAddress varchar(30),
	cardNumber bigint ,
	ages int);

CREATE TABLE customers(
	customerID int UNIQUE FOREIGN KEY REFERENCES customerDetails(customerID),
	customerFirstName varchar(20) NOT NULL,
	customerLastName varchar(20) NOT NULL,
	creditLimit real NOT NULL
	primary key (customerID) );

CREATE TABLE orderDetails(
	orderID int PRIMARY KEY,
	shippedDate date NOT NULL,
	quantity int NOT NULL,
	price real NOT NULL);

CREATE TABLE payments(
	paymentID int PRIMARY KEY NOT NULL,
	paymentDate date NOT NULL);

CREATE TABLE orders(
	customerID int REFERENCES customers(customerID),
	orderID int UNIQUE REFERENCES orderDetails(orderID),
	PRIMARY KEY (orderID),

	paymentID int UNIQUE REFERENCES payments(paymentID),
	orderDate date NOT NULL,
	statusOrder varchar(20) NOT NULL);

CREATE TABLE products_orders(
	productCode int NOT NULL,
	orderID int REFERENCES orders(orderID) NOT NULL,
	brochureID int NOT NULL,

	PRIMARY KEY (productCode, orderID,brochureID),
	FOREIGN KEY (productCode, brochureID) REFERENCES products(productCode, brochureID) ON DELETE CASCADE);
