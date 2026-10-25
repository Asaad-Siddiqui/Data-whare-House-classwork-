# Experiment 3: OLAP Operations

These MySQL scripts demonstrate slice, dice, roll-up, drill-down, and pivot operations using small star-schema datasets.

## Files

- [chit-7] Retail sales: [open SQL file](%5Bchit-7%5DRetail-Sales.sql)
- [chit-8] Hospital services: [open SQL file](%5Bchit-8%5DHospital-Services.sql)
- [chit-9] Library book borrowing: [open SQL file](%5Bchit-9%5DLibrary-Book-Borrowing.sql)
- [chit-10] Banking transactions: [open SQL file](%5Bchit-10%5DBanking-Transactions.sql)

## How to run

1. Install MySQL Server 8.x and MySQL Workbench.
2. Open one SQL file in MySQL Workbench and connect to your local server.
3. Run the complete script with the execute button.
4. Review the result grids for the OLAP queries.

Each script creates its own database with `CREATE DATABASE IF NOT EXISTS` and selects it with `USE`. You can run the scripts independently. Installations using VS Code can use a MySQL or SQLTools extension instead, but MySQL Workbench is recommended for beginners.

## Concepts covered

- **Slice:** filter one dimension, such as one year or city.
- **Dice:** filter multiple dimensions at the same time.
- **Roll-up:** aggregate from detailed levels to higher levels.
- **Drill-down:** inspect increasingly detailed levels.
- **Pivot:** compare measures across categories or years.

## Chit-wise coverage

- **Chit 7 — Retail Sales:** Slice by one year; dice by product and location; roll-up month to quarter to year; drill-down year to quarter to month.

- **Chit 8 — Hospital Services:** Slice by city; dice by two years and service category; roll-up city to state to country; drill-down country to state to city.

- **Chit 9 — Library Book Borrowing:** Slice by book category; dice by customer segment and two quarters; roll-up book to category to department; drill-down department to category to book.

- **Chit 10 — Banking Transactions:** Slice by customer segment; dice by location, product, and transaction amount; roll-up day to month to year; drill-down year to month to day.

### Important points for your practical
- Each chit uses a different domain: retail, hospital, library and banking.
- Each script creates its own database, tables and sample rows, so run one chit at a time.
- The fact tables have two measures, and the time dimensions contain day, month, quarter and year.
- `WITH ROLLUP` produces subtotals. `NULL` values in the grouping columns identify higher-level totals.
- Pivot uses `CASE WHEN` with `SUM()` to turn year or quarter values into separate columns.
- The dice query for Chit 9 uses two quarters of 2024; the dice query for Chit 10 filters the selected location and product categories, then applies the amount threshold using `HAVING`.