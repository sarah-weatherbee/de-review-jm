from datetime import datetime, timedelta

from airflow import DAG
from airflow.decorators import task
from airflow.operators.dummy import DummyOperator
from run_pipeline import create_customer_outreach_metrics

with DAG(
    'tpch_etl',
    description='A simple DAG to demonstrate steps in building a data pipeline',
    schedule_interval=timedelta(minutes=1),
    start_date=datetime(2024, 9, 23),
    catchup=False,
) as dag:

    @task
    def create_customer_outreach_metrics_task():
        create_customer_outreach_metrics()
        
    stop_pipeline = DummyOperator(task_id='stop_pipeline')

    create_customer_outreach_metrics_task() >> stop_pipeline
