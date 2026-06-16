# Coffee Shop Sales Database

## Descripción

Proyecto de modelado y transformación de datos basado en un dataset de ventas de unas cafeterías.

El objetivo del proyecto es transformar un dataset en una base de datos relacional normalizada siguiendo un enfoque orientado a Business Intelligence (BI), permitiendo realizar análisis de ventas por producto, categoría, tienda y empleado.

## Tecnologías mas usadas

* Python
* MySQL
* Jupyter Notebook

## Estructura del proyecto

```text
CoffeeShopDB/
│
├── Data/
│   └── Coffee_Shop_Sales.csv
│
├── Notebooks/
│   └── edicion_dataset.ipynb
│
├── Queries/
│   ├── schema.sql
│   └── data.sql
│
├── DiagramaEntidadRelacion.png
├── Borrador DER.png
└── README.md
```

## Proceso de transformación

A partir del dataset original se realizaron las siguientes tareas:

* Limpieza y transformación de datos mediante Python.
* Conversión de fechas y horas al formato compatible con MySQL.
* Normalización de productos y categorías.
* Creación de empleados y tiendas sintéticas para enriquecer el modelo analítico.
* Generación automática de sentencias SQL mediante Python.
* Creación automática de la base de datos y carga de datos.

### Tabla de hechos

#### SALES

Contiene las transacciones de venta.

Principales métricas:

* sale_quantity
* sale_total

### Tablas de dimensiones

#### PRODCUTS

Información de los productos vendidos.

#### CATEGORIES

Clasificación de productos.

#### STORES

Información de las tiendas.

#### EMPLOYEES

Información de los empleados asociados a cada tienda.

## Diagrama entidad-relación

El diagrama completo puede consultarse en:

* DiagramaEntidadRelacion.png

## Ejecución

1. Ejecutar el notebook:

```bash
edicion_dataset.ipynb
```

2. El notebook genera automáticamente:

* schema.sql
* data.sql

3. Ejecutar ambos scripts en MySQL:

## Posibles análisis futuros

* Ventas por categoría.
* Productos más vendidos.
* Ventas por tienda.
* Rendimiento por empleado.
* Evolución temporal de las ventas.
* Ticket medio por producto.

## Dataset

Dataset original de ventas de cafetería obtenido de Kaggle y adaptado para fines educativos y de portfolio.
https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales
