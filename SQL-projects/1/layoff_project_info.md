<h1>Layoffs Data Analysis and Cleaning</h1>
<p>
    This repository contains SQL scripts and steps to analyze and clean a dataset related to layoffs across various companies. 
    The dataset includes key metrics such as company details, location, industry, total layoffs, percentage laid off, funding stage, and country. 
    The primary objective of this project is to clean, standardize, and analyze the data to draw insights about layoffs trends.
</p>

<h2>Project Overview</h2>

<h3>1. Data Cleaning Steps</h3>
<p>The following steps were performed to clean the dataset:</p>

<h4>1.1 Creating Backup of Raw Data</h4>
<ul>
    <li>A staging table (<code>layoffs_staging</code>) was created to ensure the original data remains untouched.</li>
</ul>

<h4>1.2 Removing Duplicates</h4>
<ul>
    <li>Identified duplicate rows using <code>ROW_NUMBER()</code> in a Common Table Expression (CTE).</li>
    <li>Created a second staging table (<code>layoffs_staging2</code>) with unique rows by deleting duplicates.</li>
</ul>

<h4>1.3 Standardizing the Data</h4>
<ul>
    <li><strong>Trimmed extra spaces</strong> in string fields (e.g., <code>company</code>, <code>country</code>).</li>
    <li><strong>Unified naming conventions</strong>:
        <ul>
            <li>Corrected inconsistent industry names (e.g., "Crypto" variations standardized to "Crypto").</li>
            <li>Removed trailing dots from country names (e.g., "United States.").</li>
        </ul>
    </li>
    <li><strong>Date standardization:</strong> Converted <code>date</code> from text to <code>DATE</code> format using <code>STR_TO_DATE()</code>.</li>
</ul>

<h4>1.4 Handling NULL or Blank Values</h4>
<ul>
    <li>Replaced blank or NULL industry values using reference data where available (e.g., matching <code>company</code> and <code>location</code>).</li>
    <li>Deleted rows with missing critical fields (e.g., <code>percentage_laid_off</code> and <code>total_laid_off</code>).</li>
</ul>

<h4>1.5 Removing Unnecessary Columns</h4>
<ul>
    <li>Dropped temporary or auxiliary columns such as <code>row_number</code> after their purpose was served.</li>
</ul>

<h3>2. Exploratory Data Analysis (EDA)</h3>
<p>The cleaned data was analyzed to extract meaningful insights using SQL queries. Key analyses include:</p>

<h4>2.1 Summary Statistics</h4>
<ul>
    <li>Maximum and minimum values of <code>total_laid_off</code> and <code>percentage_laid_off</code>.</li>
</ul>

<h4>2.2 Trend Analysis</h4>
<ul>
    <li><strong>Yearly layoffs trend:</strong> Grouped layoffs by year and ordered results to observe yearly changes.</li>
    <li><strong>Monthly layoffs trend:</strong> Aggregated layoffs by month to observe finer trends.</li>
</ul>

<h4>2.3 Top Companies by Layoffs</h4>
<ul>
    <li>Companies with the highest total layoffs in a given year (<code>DENSE_RANK()</code>).</li>
</ul>

<h4>2.4 Industry Analysis</h4>
<ul>
    <li>Total layoffs grouped by industry, highlighting sectors most affected by layoffs.</li>
</ul>

<h4>2.5 Country-wise Analysis</h4>
<ul>
    <li>Total layoffs by country, identifying geographical patterns.</li>
</ul>

<h4>2.6 Stage Analysis</h4>
<ul>
    <li>Layoffs grouped by funding stage (e.g., Post-IPO, Series B).</li>
</ul>

<h4>2.7 Rolling Totals</h4>
<ul>
    <li>Monthly rolling totals for layoffs and funds raised by company.</li>
</ul>

<h2>How to Use</h2>

<h3>Setup the Database</h3>
<ol>
    <li>Import the raw data into a database (e.g., MySQL).</li>
    <li>Use the provided SQL scripts to clean and analyze the data.</li>
</ol>

<h3>Data Cleaning</h3>
<ol>
    <li>Follow the SQL scripts sequentially to replicate the cleaning process.</li>
</ol>

<h3>Data Analysis</h3>
<ol>
    <li>Run the exploratory queries to extract insights or modify them for your specific use case.</li>
</ol>

<h2>Dataset Description</h2>

<table>
    <thead>
        <tr>
            <th>Column Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>company</code></td>
            <td>Name of the company</td>
        </tr>
        <tr>
            <td><code>location</code></td>
            <td>City of the company's headquarters</td>
        </tr>
        <tr>
            <td><code>industry</code></td>
            <td>Industry sector</td>
        </tr>
        <tr>
            <td><code>total_laid_off</code></td>
            <td>Number of employees laid off</td>
        </tr>
        <tr>
            <td><code>percentage_laid_off</code></td>
            <td>Percentage of the workforce laid off</td>
        </tr>
        <tr>
            <td><code>date</code></td>
            <td>Date of the layoffs</td>
        </tr>
        <tr>
            <td><code>stage</code></td>
            <td>Funding stage of the company (e.g., Post-IPO, Series B)</td>
        </tr>
        <tr>
            <td><code>country</code></td>
            <td>Country of the company</td>
        </tr>
        <tr>
            <td><code>funds_raised_millions</code></td>
            <td>Total funds raised in millions by the company</td>
        </tr>
    </tbody>
</table>

<h2>Tools Used</h2>
<ul>
    <li><strong>Database:</strong> MySQL</li>
    <li><strong>SQL Techniques:</strong> CTEs, Window Functions, Aggregations, and Joins</li>
</ul>

<h2>Author</h2>
<p>
    <strong>Hida Ismail</strong><br>
    Aspiring Data Analyst with expertise in Python, MySQL, Power BI, and Excel.
</p>
