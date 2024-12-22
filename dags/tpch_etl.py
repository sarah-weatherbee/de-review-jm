from datetime import datetime, timedelta

from run_pipeline import create_customer_outreach_metrics

from airflow import DAG
from airflow.decorators import task
from airflow.operators.dummy import DummyOperator

with DAG(
    'tpch_etl',
    description='Demo DAG',
    schedule_interval=timedelta(minutes=1),
    start_date=datetime(2024, 9, 23),
    catchup=False,
) as dag:

    @task
    def create_customer_outreach_metrics_task():
        create_customer_outreach_metrics()

    stop_pipeline = DummyOperator(task_id='stop_pipeline')

    create_customer_outreach_metrics_task() >> stop_pipeline
