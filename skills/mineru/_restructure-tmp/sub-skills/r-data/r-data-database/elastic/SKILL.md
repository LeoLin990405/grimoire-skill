---
name: elastic
description: R elastic package for Elasticsearch. Use for connecting to Elasticsearch and performing search operations.
---

# elastic

Elasticsearch client for R.

## Connection

```r
library(elastic)

# Connect to local Elasticsearch
connect()

# Connect with options
connect(
  host = "localhost",
  port = 9200,
  user = "elastic",
  pwd = "password"
)

# Check connection
ping()
```

## Index Operations

```r
# Create index
index_create("myindex")

# Create with settings
index_create("myindex", body = '{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {
      "title": {"type": "text"},
      "date": {"type": "date"},
      "count": {"type": "integer"}
    }
  }
}')

# Check if exists
index_exists("myindex")

# Delete index
index_delete("myindex")

# List indices
cat_indices()
```

## Indexing Documents

```r
# Index single document
docs_create(index = "myindex", id = 1, body = list(
  title = "Hello",
  content = "World",
  date = Sys.Date()
))

# Bulk index
docs_bulk(df, index = "myindex")

# Bulk from file
docs_bulk("data.json", index = "myindex")
```

## Search

```r
# Simple search
Search(index = "myindex", q = "hello")

# Query DSL
Search(index = "myindex", body = '{
  "query": {
    "match": {
      "title": "hello"
    }
  }
}')

# Bool query
Search(index = "myindex", body = '{
  "query": {
    "bool": {
      "must": [
        {"match": {"title": "hello"}},
        {"range": {"date": {"gte": "2024-01-01"}}}
      ]
    }
  }
}')

# With pagination
Search(index = "myindex", size = 10, from = 0)

# With sorting
Search(index = "myindex", body = '{
  "query": {"match_all": {}},
  "sort": [{"date": "desc"}]
}')
```

## Aggregations

```r
# Terms aggregation
Search(index = "myindex", body = '{
  "size": 0,
  "aggs": {
    "categories": {
      "terms": {"field": "category.keyword"}
    }
  }
}')

# Date histogram
Search(index = "myindex", body = '{
  "size": 0,
  "aggs": {
    "by_month": {
      "date_histogram": {
        "field": "date",
        "calendar_interval": "month"
      }
    }
  }
}')

# Nested aggregations
Search(index = "myindex", body = '{
  "size": 0,
  "aggs": {
    "by_category": {
      "terms": {"field": "category.keyword"},
      "aggs": {
        "avg_price": {"avg": {"field": "price"}}
      }
    }
  }
}')
```

## Get and Delete

```r
# Get document by ID
docs_get(index = "myindex", id = 1)

# Delete document
docs_delete(index = "myindex", id = 1)

# Delete by query
docs_delete_by_query(index = "myindex", body = '{
  "query": {"match": {"status": "deleted"}}
}')
```

## Update

```r
# Update document
docs_update(index = "myindex", id = 1, body = '{
  "doc": {"status": "updated"}
}')

# Update by query
docs_update_by_query(index = "myindex", body = '{
  "query": {"match": {"status": "pending"}},
  "script": {"source": "ctx._source.status = \"processed\""}
}')
```

## Scroll (Large Results)

```r
# Initialize scroll
res <- Search(index = "myindex", scroll = "1m", size = 1000)

# Get scroll ID
scroll_id <- res$`_scroll_id`

# Continue scrolling
while (length(res$hits$hits) > 0) {
  res <- scroll(scroll_id = scroll_id, scroll = "1m")
  # Process results
}

# Clear scroll
scroll_clear(scroll_id)
```
