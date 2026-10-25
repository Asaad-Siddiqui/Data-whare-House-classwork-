# Data Warehouse Classwork

This repository contains practical experiments for data warehousing, data preprocessing, clustering, OLAP SQL, and web scraping.

## Experiments

| Experiment | Topic | Files and guide |
| --- | --- | --- |
| 3 | OLAP operations with SQL | [Open Exp3 README](Exp3%20-%20Olap%20Operations/README.md) |
| 4 | Data preprocessing and exploration | [Open Exp4 README](Exp4%20-%20Data%20Preprocessing%20and%20Exploration/README.md) |
| 5 | Data transformation and skewness | [Open Exp5 README](Exp5%20-%20Data%20Transformation%20and%20Skewness/README.md) |
| 7 | K-means clustering | [Open Exp7 README](Exp7%20-%20K-means%20Clustering/README.md) |
| 12 | Web scraping | [Open Exp12 README](Exp12%20-%20WebScraping/README.md) |

## Recommended applications

### Python notebooks

Use **VS Code** with the **Python** and **Jupyter** extensions. This is the best option for keeping the notebooks and their files together in this repository. **Google Colab** is a good alternative when you do not want to install Python locally.

### MySQL scripts

Use **MySQL Workbench** with a local MySQL Server 8.x installation. It provides a query editor, database browser, and result tables. VS Code with a MySQL/SQLTools extension is also suitable, but Workbench is the simplest choice for these scripts.

### Web scraping notebooks

Run them in VS Code Jupyter or Google Colab with an internet connection. These notebooks use `books.toscrape.com` and `quotes.toscrape.com`, which are practice sites.

## Python setup

From the repository root on Linux or macOS:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m jupyter lab
```

On Windows, activate the environment with `.venv\\Scripts\\activate` instead.

In VS Code, select the `.venv` interpreter and open any `.ipynb` file. Run notebook cells from top to bottom. Most notebooks contain sample data and do not require additional files; Chit 22 can optionally load `Mall_Customers.csv`.

## MySQL setup

1. Install MySQL Server 8.x and MySQL Workbench.
2. Start MySQL and connect to your local server in Workbench.
3. Open an SQL file from the Exp3 folder.
4. Run the complete script. Each script creates and selects its own database.
5. Execute the `SELECT` statements and inspect the result grids.

## Naming convention

Files use the format `[chit-N]Short-Descriptive-Name`, for example `[chit-19]KMeans-K3-Iris.ipynb`. Folder READMEs are named `README.md` and contain the execution instructions for that experiment.