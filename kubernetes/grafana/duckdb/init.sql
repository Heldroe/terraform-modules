-- Install and load extensions
INSTALL httpfs;
LOAD httpfs;

INSTALL cache_httpfs from community;
LOAD cache_httpfs;

INSTALL aws;
LOAD aws;

-- Set object storage configuration
CREATE OR REPLACE SECRET scaleway_s3 (
    TYPE s3,
    PROVIDER credential_chain,
    CHAIN 'env;config',
    ENDPOINT '${s3_endpoint}',
    REGION '${s3_region}',
    URL_STYLE 'vhost',
    SCOPE 's3://${s3_bucket_name}'
);
SET http_retries = 3;
SET http_retry_wait_ms = 500;
SET http_retry_backoff = 2;

-- Object storage local caching
SET cache_httpfs_type='on_disk';
SET cache_httpfs_glob_cache_entry_timeout_millisec = 60000;

%{ if daily_compaction }

-- Query in daily mode
CREATE OR REPLACE MACRO logs(log_group, start_time, end_time) AS TABLE (
    SELECT
        * REPLACE (time::TIMESTAMP AS time)
    FROM read_parquet([
        's3://${s3_bucket_name}/daily/' || log_group || '/*/*/*/*/data.parquet',
        's3://${s3_bucket_name}/hourly/' || log_group || '/*/*/*/*/data.parquet',
        's3://${s3_bucket_name}/raw/' || log_group || '/*/*/*/*/*.parquet'
    ], hive_partitioning = true, filename = true, union_by_name = true)
    WHERE
        (
            (
                filename NOT LIKE '%/daily/%'
                AND make_timestamp(year::BIGINT, month::BIGINT, day::BIGINT, COALESCE(hour::BIGINT, 0), 0, 0)
                    BETWEEN date_trunc('hour', start_time::TIMESTAMP) - INTERVAL 1 HOUR
                        AND date_trunc('hour', end_time::TIMESTAMP) + INTERVAL 1 HOUR
            )
            OR
            (
                filename LIKE '%/daily/%'
                AND make_date(year::BIGINT, month::BIGINT, day::BIGINT)
                    BETWEEN start_time::DATE AND end_time::DATE
            )
        )
        AND time::TIMESTAMP BETWEEN start_time::TIMESTAMP AND end_time::TIMESTAMP
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY time::TIMESTAMP DESC) = 1
);

%{ else }

-- Query in hourly mode
CREATE OR REPLACE MACRO logs(log_group, start_time, end_time) AS TABLE (
    SELECT
        * REPLACE (time::TIMESTAMP AS time)
    FROM read_parquet([
        's3://${s3_bucket_name}/hourly/' || log_group || '/*/*/*/*/data.parquet',
        's3://${s3_bucket_name}/raw/' || log_group || '/*/*/*/*/*.parquet'
    ], hive_partitioning = true, union_by_name = true)
    WHERE make_timestamp(year::BIGINT, month::BIGINT, day::BIGINT, hour::BIGINT, 0, 0)
            BETWEEN date_trunc('hour', start_time::TIMESTAMP) - INTERVAL 1 HOUR
                AND date_trunc('hour', end_time::TIMESTAMP) + INTERVAL 1 HOUR
      AND time::TIMESTAMP BETWEEN start_time::TIMESTAMP AND end_time::TIMESTAMP
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY time::TIMESTAMP DESC) = 1
);

%{ endif }

CREATE OR REPLACE MACRO raw_logs(log_group, start_time, end_time) AS TABLE (
    SELECT
        * REPLACE (time::TIMESTAMP AS time)
    FROM read_parquet([
        's3://${s3_bucket_name}/raw/' || log_group || '/*/*/*/*/*.parquet'
    ], hive_partitioning = true, union_by_name = true)
    WHERE make_timestamp(year::BIGINT, month::BIGINT, day::BIGINT, hour::BIGINT, 0, 0)
            BETWEEN date_trunc('hour', start_time::TIMESTAMP) - INTERVAL 1 HOUR
                AND date_trunc('hour', end_time::TIMESTAMP) + INTERVAL 1 HOUR
      AND time::TIMESTAMP BETWEEN start_time::TIMESTAMP AND end_time::TIMESTAMP
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY time::TIMESTAMP DESC) = 1
);
