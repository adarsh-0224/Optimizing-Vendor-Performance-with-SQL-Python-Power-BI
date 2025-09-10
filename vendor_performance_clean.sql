SHOW TABLES;

DESCRIBE vendor_master;
DESCRIBE item_master;
DESCRIBE vendor_purchase_orders;

-- Vendor Master cleanup
ALTER TABLE vendor_master 
MODIFY vendor_id VARCHAR(10),
MODIFY vendor_name VARCHAR(100),
MODIFY vendor_location VARCHAR(100),
MODIFY vendor_rating DECIMAL(3,2);

-- Item Master cleanup
ALTER TABLE item_master 
MODIFY item_id VARCHAR(10),
MODIFY item_name VARCHAR(100),
MODIFY category VARCHAR(50);

-- Purchase Orders cleanup
ALTER TABLE vendor_purchase_orders 
MODIFY po_id VARCHAR(10),
MODIFY po_date DATE,
MODIFY vendor_id VARCHAR(10),
MODIFY item_id VARCHAR(10),
MODIFY qty_ordered INT,
MODIFY qty_received INT,
MODIFY unit_cost DECIMAL(10,2);


-- ALTER TABLE vendor_master ADD PRIMARY KEY (vendor_id);
-- ALTER TABLE item_master ADD PRIMARY KEY (item_id);

-- ALTER TABLE vendor_purchase_orders 
-- ADD PRIMARY KEY (po_id),
-- ADD CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES vendor_master(vendor_id),
-- ADD CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES item_master(item_id);


SHOW KEYS FROM vendor_master WHERE Key_name = 'PRIMARY';
SHOW KEYS FROM item_master WHERE Key_name = 'PRIMARY';
SHOW KEYS FROM vendor_purchase_orders WHERE Key_name = 'PRIMARY';


-- Total number of vendors, items, and purchase orders
SELECT COUNT(*) AS total_vendors FROM vendor_master;
SELECT COUNT(*) AS total_items FROM item_master;
SELECT COUNT(*) AS total_orders FROM vendor_purchase_orders;

-- Total spend per vendor
SELECT v.vendor_id, v.vendor_name, 
       SUM(p.qty_received * p.unit_cost) AS total_spend
FROM vendor_purchase_orders p
JOIN vendor_master v ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_id, v.vendor_name
ORDER BY total_spend DESC;

-- Fill rate (qty_received / qty_ordered)
SELECT v.vendor_name,
       SUM(p.qty_received) / SUM(p.qty_ordered) * 100 AS fill_rate_pct
FROM vendor_purchase_orders p
JOIN vendor_master v ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_name;

-- Average unit cost per item
SELECT i.item_name, AVG(p.unit_cost) AS avg_unit_cost
FROM vendor_purchase_orders p
JOIN item_master i ON p.item_id = i.item_id
GROUP BY i.item_name;

-- vendors by spend
SELECT v.vendor_name, SUM(p.qty_received * p.unit_cost) AS spend
FROM vendor_purchase_orders p
JOIN vendor_master v ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY spend DESC
LIMIT 5;


