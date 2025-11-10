------------------------------------
--QUESTION 1
------------------------------------
-- Create the DONOR table
CREATE TABLE DONOR (
    DONOR_ID VARCHAR2(10) PRIMARY KEY,
    DONOR_NAME VARCHAR2(50) NOT NULL,
    CONTACT_NO VARCHAR2(15),
    EMAIL VARCHAR2(50)
);

-- Create the BIKE table
CREATE TABLE BIKE (
    BIKE_ID VARCHAR2(10) PRIMARY KEY,
    DESCRIPTION VARCHAR2(50) NOT NULL,
    BIKE_TYPE VARCHAR2(30) NOT NULL,
    MANUFACTURER VARCHAR2(30) NOT NULL
);

-- Create the VOLUNTEER table
CREATE TABLE VOLUNTEER (
    VOLUNTEER_ID VARCHAR2(10) PRIMARY KEY,
    VOL_NAME VARCHAR2(50) NOT NULL,
    ROLE VARCHAR2(30)
);

-- Create the DONATION table
CREATE TABLE DONATION (
    DONATION_ID NUMBER PRIMARY KEY,
    DONOR_ID VARCHAR2(10) NOT NULL,
    BIKE_ID VARCHAR2(10) NOT NULL,
    VALUE NUMBER(10,2) CHECK (VALUE > 0),
    VOLUNTEER_ID VARCHAR2(10) NOT NULL,
    DONATION_DATE DATE NOT NULL,
    CONSTRAINT fk_donor FOREIGN KEY (DONOR_ID) REFERENCES DONOR(DONOR_ID),
    CONSTRAINT fk_bike FOREIGN KEY (BIKE_ID) REFERENCES BIKE(BIKE_ID),
    CONSTRAINT fk_volunteer FOREIGN KEY (VOLUNTEER_ID) REFERENCES VOLUNTEER(VOLUNTEER_ID)
);

-- Insert BIKE data
INSERT INTO BIKE VALUES ('B001', 'BMX AX1', 'Road Bike', 'BMX');
INSERT INTO BIKE VALUES ('B002', 'Giant Domain 1', 'Road Bike', 'Giant');
INSERT INTO BIKE VALUES ('B003', 'Ascent 26In', 'Mountain Bike', 'Raleigh');
INSERT INTO BIKE VALUES ('B004', 'Canyon 6X', 'Kids Bike', 'Canyon');
INSERT INTO BIKE VALUES ('B005', 'Marvel', 'Gravel Road Bike', 'BMX');
INSERT INTO BIKE VALUES ('B006', 'Mountain 21 Speed', 'Mountain Bike', 'BMX');
INSERT INTO BIKE VALUES ('B007', 'Canyon Roadster', 'Road Bike', 'Canyon');
INSERT INTO BIKE VALUES ('B008', 'Legion 101', 'Hybrid Bike', 'BMX');
INSERT INTO BIKE VALUES ('B009', 'Madonna 9', 'Road Bike', 'Trek');
INSERT INTO BIKE VALUES ('B010', 'Comp 2022', 'Mountain Bike', 'Trek');
INSERT INTO BIKE VALUES ('B011', 'BMX AX15', 'Road Bike', 'BMX');

-- Insert DONOR data
INSERT INTO DONOR VALUES ('DID11', 'Jeff Wanya', '0827172250', 'wanyajeff@ymail.com');
INSERT INTO DONOR VALUES ('DID12', 'Sthembeni Pisho', '0837865670', 'sthepisho@ymail.com');
INSERT INTO DONOR VALUES ('DID13', 'James Temba', '0878978650', 'jimmy@ymail.com');
INSERT INTO DONOR VALUES ('DID14', 'Luramo Misi', '0826575650', 'luramom@ymail.com');
INSERT INTO DONOR VALUES ('DID15', 'Abraham Xolani', '0797656430', 'axolani@ymail.com');
INSERT INTO DONOR VALUES ('DID16', 'Rumi Jones', '0668899221', 'rjones@true.com');
INSERT INTO DONOR VALUES ('DID17', 'Xolani Redo', '0614553389', 'xredo@ymail.com');
INSERT INTO DONOR VALUES ('DID18', 'Tenny Stars', '0824228870', 'tenstars@true.com');
INSERT INTO DONOR VALUES ('DID19', 'Tiny Rambo', '0715554333', 'trambo@ymail.com');
INSERT INTO DONOR VALUES ('DID20', 'Yannick Leons', '0615554323', 'yleons@true.com');

-- Insert VOLUNTEER data
INSERT INTO VOLUNTEER VALUES ('vol101', 'Kenny Temba', 'Manager');
INSERT INTO VOLUNTEER VALUES ('vol102', 'Mamelodi Marks', 'Coordinator');
INSERT INTO VOLUNTEER VALUES ('vol103', 'Ada Andrews', 'Coordinator');
INSERT INTO VOLUNTEER VALUES ('vol104', 'Evans Tambala', 'Assistant');
INSERT INTO VOLUNTEER VALUES ('vol105', 'Xolani Samson', 'Supervisor');

-- Insert DONATION data
INSERT INTO DONATION VALUES (1,  'DID11', 'B001', 1500, 'vol101', TO_DATE('01-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (2,  'DID12', 'B002', 2500, 'vol101', TO_DATE('03-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (3,  'DID13', 'B003', 1000, 'vol103', TO_DATE('03-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (4,  'DID14', 'B004', 1750, 'vol105', TO_DATE('05-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (5,  'DID15', 'B006', 2000, 'vol101', TO_DATE('07-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (6,  'DID16', 'B007', 1800, 'vol105', TO_DATE('09-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (7,  'DID17', 'B008', 1500, 'vol101', TO_DATE('15-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (8,  'DID18', 'B009', 1500, 'vol103', TO_DATE('19-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (9,  'DID12', 'B010', 2500, 'vol103', TO_DATE('25-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (10, 'DID20', 'B005', 3500, 'vol105', TO_DATE('05-May-2023','DD-Mon-YYYY'));
INSERT INTO DONATION VALUES (11, 'DID19', 'B011', 2500, 'vol103', TO_DATE('30-May-2023','DD-Mon-YYYY'));

------------------------------------
--QUESTION 2
------------------------------------
SELECT 
    d.DONOR_ID AS "Donor ID",
    b.BIKE_TYPE AS "Bike Type",
    b.DESCRIPTION AS "Bike Description",
    'R ' || TO_CHAR(n.VALUE, '9990') AS "Bike Value"
FROM 
    DONATION n
    JOIN DONOR d ON n.DONOR_ID = d.DONOR_ID
    JOIN BIKE b ON n.BIKE_ID = b.BIKE_ID
WHERE 
    n.VALUE > 1500;

------------------------------------
--QUESTION 3
------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    -- Constant declaration
    v_vat_rate CONSTANT NUMBER := 0.15;

    -- Variable declarations
    v_description  BIKE.DESCRIPTION%TYPE;
    v_manufacturer BIKE.MANUFACTURER%TYPE;
    v_type         BIKE.BIKE_TYPE%TYPE;
    v_value        DONATION.VALUE%TYPE;
    v_vat_amount   NUMBER;
    v_total        NUMBER;

    -- Cursor for Road Bikes only
    CURSOR road_bikes_cur IS
        SELECT b.DESCRIPTION, b.MANUFACTURER, b.BIKE_TYPE, n.VALUE
        FROM BIKE b
        JOIN DONATION n ON b.BIKE_ID = n.BIKE_ID
        WHERE b.BIKE_TYPE = 'Road Bike';

BEGIN
    -- Loop through cursor results
    FOR bike_rec IN road_bikes_cur LOOP
        -- Assign values
        v_description  := bike_rec.DESCRIPTION;
        v_manufacturer := bike_rec.MANUFACTURER;
        v_type         := bike_rec.BIKE_TYPE;
        v_value        := bike_rec.VALUE;

        -- Calculate VAT and total
        v_vat_amount := v_value * v_vat_rate;
        v_total      := v_value + v_vat_amount;

        -- Output results
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
        DBMS_OUTPUT.PUT_LINE('BIKE DESCRIPTION: ' || v_description);
        DBMS_OUTPUT.PUT_LINE('BIKE MANUFACTURER: ' || v_manufacturer);
        DBMS_OUTPUT.PUT_LINE('BIKE TYPE: ' || v_type);
        DBMS_OUTPUT.PUT_LINE('VALUE: R' || TO_CHAR(v_value, '9G999'));
        DBMS_OUTPUT.PUT_LINE('VAT: R' || TO_CHAR(v_vat_amount, '9G999'));
        DBMS_OUTPUT.PUT_LINE('TOTAL AMNT: R' || TO_CHAR(v_total, '9G999'));
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
    END LOOP;
END;
/

------------------------------------
--QUESTION 4
------------------------------------
CREATE OR REPLACE VIEW vwBikeRUs AS
SELECT 
    d.DONOR_NAME AS DONOR_NAME,
    d.CONTACT_NO AS CONTACT_NO,
    b.BIKE_TYPE AS BIKE_TYPE,
    TO_CHAR(n.DONATION_DATE, 'DD/Mon/YY') AS DONATION_DATE
FROM 
    DONATION n
    JOIN DONOR d ON n.DONOR_ID = d.DONOR_ID
    JOIN BIKE b ON n.BIKE_ID = b.BIKE_ID
WHERE 
    n.VOLUNTEER_ID = 'vol105';

SELECT * FROM vwBikeRUs;

-- ===========================================================
-- Justification for using a VIEW
-- ===========================================================
/*
Justification – Benefits of Using a View:
1. **Data Security:** 
   Views allow limited access to specific columns and rows (e.g., only donors assisted by vol105) 
   without giving users full access to the underlying tables. This helps protect sensitive donor information.

2. **Simplified Querying:**
   The view combines data from multiple tables (DONOR, BIKE, DONATION) into one logical table, 
   making it easier for users to retrieve frequently needed information with a simple SELECT statement.

These benefits improve data management, consistency, and security for BikeRUs staff.
*/
------------------------------------
--QUESTION 5
------------------------------------
--Create the procedure
CREATE OR REPLACE PROCEDURE spDonorDetails(p_bike_id IN BIKE.BIKE_ID%TYPE) 
IS
    -- Variable declarations
    v_donor_name     DONOR.DONOR_NAME%TYPE;
    v_contact_no     DONOR.CONTACT_NO%TYPE;
    v_volunteer_name VOLUNTEER.VOL_NAME%TYPE;
    v_bike_desc      BIKE.DESCRIPTION%TYPE;
    v_donation_date  DONATION.DONATION_DATE%TYPE;

-- Exception for missing data
BEGIN
    -- Select donor, volunteer, and bike details based on input bike ID
    SELECT 
        d.DONOR_NAME,
        d.CONTACT_NO,
        v.VOL_NAME,
        b.DESCRIPTION,
        n.DONATION_DATE
    INTO 
        v_donor_name,
        v_contact_no,
        v_volunteer_name,
        v_bike_desc,
        v_donation_date
    FROM 
        DONATION n
        JOIN DONOR d ON n.DONOR_ID = d.DONOR_ID
        JOIN VOLUNTEER v ON n.VOLUNTEER_ID = v.VOLUNTEER_ID
        JOIN BIKE b ON n.BIKE_ID = b.BIKE_ID
    WHERE 
        n.BIKE_ID = p_bike_id;

    -- Display formatted output
    DBMS_OUTPUT.PUT_LINE('ATTENTION: ' || v_donor_name || 
                         ' assisted by: ' || v_volunteer_name ||
                         ', donated the ' || v_bike_desc ||
                         ' on the ' || TO_CHAR(v_donation_date, 'DD/Mon/YY'));

EXCEPTION
    -- Handle case where no record matches the input Bike ID
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No donor record found for Bike ID: ' || p_bike_id);

    -- Handle any other unexpected errors
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);

END spDonorDetails;
/

-- Enable output display
SET SERVEROUTPUT ON;

-- Execute the procedure for Bike ID 'B004'
BEGIN
    spDonorDetails('B004');
END;
/
------------------------------------
--QUESTION 6
------------------------------------
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_TotalDonationValue(p_donor_id IN DONOR.DONOR_ID%TYPE)
RETURN NUMBER
IS
    v_total_value  NUMBER := 0;  -- Variable to store calculated total
BEGIN
    -- Calculate the total value of donations for the given donor
    SELECT SUM(VALUE)
    INTO v_total_value
    FROM DONATION
    WHERE DONOR_ID = p_donor_id;

    -- Handle case where donor has no donations
    IF v_total_value IS NULL THEN
        v_total_value := 0;
    END IF;

    RETURN v_total_value;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- No record found for given donor
        DBMS_OUTPUT.PUT_LINE('No donations found for Donor ID: ' || p_donor_id);
        RETURN 0;

    WHEN OTHERS THEN
        -- Generic error handling
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        RETURN 0;
END;
/

DECLARE
    v_donor_id      DONOR.DONOR_ID%TYPE := 'DID12';  -- Example donor ID
    v_total_value   NUMBER;
    v_donor_name    DONOR.DONOR_NAME%TYPE;
BEGIN
    -- Retrieve donor name for display
    SELECT DONOR_NAME INTO v_donor_name
    FROM DONOR
    WHERE DONOR_ID = v_donor_id;

    -- Call the function to get total donation value
    v_total_value := fn_TotalDonationValue(v_donor_id);

    -- Display results in formatted message
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Donor Name: ' || v_donor_name);
    DBMS_OUTPUT.PUT_LINE('Total Value of Donations: R' || TO_CHAR(v_total_value, '9G999'));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Donor not found in the database.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error occurred: ' || SQLERRM);
END;
/

------------------------------------
--QUESTION 7
------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    -- Variable declarations
    v_bike_id       BIKE.BIKE_ID%TYPE;
    v_bike_type     BIKE.BIKE_TYPE%TYPE;
    v_manufacturer  BIKE.MANUFACTURER%TYPE;
    v_value         DONATION.VALUE%TYPE;
    v_status        VARCHAR2(10);

    -- Cursor to get all bikes and their donation values
    CURSOR bike_cur IS
        SELECT 
            b.BIKE_ID,
            b.BIKE_TYPE,
            b.MANUFACTURER,
            n.VALUE
        FROM 
            BIKE b
            JOIN DONATION n ON b.BIKE_ID = n.BIKE_ID;

BEGIN
    -- Loop through all bikes
    FOR bike_rec IN bike_cur LOOP
        v_bike_id := bike_rec.BIKE_ID;
        v_bike_type := bike_rec.BIKE_TYPE;
        v_manufacturer := bike_rec.MANUFACTURER;
        v_value := bike_rec.VALUE;

        -- IF...ELSIF...ELSE to determine status
        IF v_value <= 1500 THEN
            v_status := '*'; -- 1-star
        ELSIF v_value > 1500 AND v_value <= 3000 THEN
            v_status := '**'; -- 2-star
        ELSE
            v_status := '***'; -- 3-star
        END IF;

        -- Display output in required format
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
        DBMS_OUTPUT.PUT_LINE('BIKE ID: ' || v_bike_id);
        DBMS_OUTPUT.PUT_LINE('BIKE TYPE: ' || v_bike_type);
        DBMS_OUTPUT.PUT_LINE('BIKE MANUFACTURER: ' || v_manufacturer);
        DBMS_OUTPUT.PUT_LINE('BIKE VALUE: R' || TO_CHAR(v_value, '9G999'));
        DBMS_OUTPUT.PUT_LINE('STATUS: ' || v_status);
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;
END;
/

------------------------------------
--QUESTION 8
------------------------------------
SELECT 
    d.bike_id AS "BIKE ID",
    b.bike_type AS "BIKE TYPE",
    b.manufacturer AS "MANUFACTURER",
    d."VALUE" AS "BIKE VALUE",
    CASE 
        WHEN d."VALUE" <= 1500 THEN '*'
        WHEN d."VALUE" > 1500 AND d."VALUE" <= 3000 THEN '**'
        WHEN d."VALUE" > 3000 THEN '***'
    END AS "STATUS"
FROM donation d
JOIN bike b ON d.bike_id = b.bike_id
ORDER BY d.bike_id;

    
------------------------------------
--QUESTION 9
------------------------------------
--Q 9.1
------------------------------------
CREATE OR REPLACE TRIGGER trg_prevent_donation_delete
BEFORE DELETE ON DONATION
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'ERROR: Deletion of donation records is not allowed!');
END;
/

-- Attempt to delete a record
DELETE FROM DONATION WHERE DONATION_ID = 1;
------------------------------------
--Q 9.2
------------------------------------
CREATE OR REPLACE TRIGGER trg_validate_donation_value
BEFORE UPDATE OF VALUE ON DONATION
FOR EACH ROW
BEGIN
    IF :NEW.VALUE <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Donation value must be greater than 0!');
    END IF;
END;
/

-- Test with an invalid value (should fail)
UPDATE DONATION
SET VALUE = 0
WHERE DONATION_ID = 2;

-- Test with a valid value (should succeed)
UPDATE DONATION
SET VALUE = 2500
WHERE DONATION_ID = 2;

------------------------------------
-- CLEANUP SECTION
-- Ensures the script can be rerun safely
------------------------------------

-- Drop view if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP VIEW vwBikeRUs';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN  -- ORA-00942: table or view does not exist
            RAISE;
        END IF;
END;
/

-- Drop triggers if exist
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_prevent_donation_delete';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4080 THEN  -- ORA-04080: trigger does not exist
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_validate_donation_value';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4080 THEN
            RAISE;
        END IF;
END;
/

-- Drop procedure if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE spDonorDetails';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN  -- ORA-04043: object does not exist
            RAISE;
        END IF;
END;
/

-- Drop function if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP FUNCTION fn_TotalDonationValue';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

-- Drop tables in correct order (child → parent)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DONATION CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE VOLUNTEER CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE BIKE CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DONOR CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

------------------------------------
-- CLEANUP COMPLETE
------------------------------------
