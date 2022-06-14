#! /bin/bash

get_help () {
    printf "%s" "
It gets tables from your postgresql database and open preety tables right in your browser

If run without any specified query, it will generate html table for each one postgres table in database

Syntax: pgprev [-h|f|q|p|n]
options:
-h    print this message
-f    load queries from file
-q    provide exact (single) query
-p    provide postgres connection URI for connecting to postgres server
    "
}

STYLE="
<style type='text/css'>
* {
    font-family: Roboto;
    margin: 0px;
}

h1 {
    margin: 20px;
}

.ps {
    color: #888;
    margin-right: 10px;
}

table {
    /* border-collapse: collapse; */   
    border-collapse: separate;
    border-spacing: 0px;
    vertical-align: middle;
    margin: 20px;

}

th, td {
    border: 1px solid black;
    padding: 5px 8px;
}

th {
    background-color: #222;
    color: white;
    position: sticky;
    border-left: 1px solid #888;
    border-right: 1px solid #888;
    top: 0;
}

th:last-child {
    border-right: 1px solid black;
}

th:first-child {
    border-left: 1px solid black;
}

/* Stripes */
tr:nth-child(even) {
    background-color: #fafafa;
}

tr:nth-child(odd) {
    background-color: #efefef;
}


</style>
"


# DEFAULT VALUES:
TAB_CONTENT="none"


while getopts "hq:f:p:" opt; do
  case $opt in
    h)  # Print help and exit
        get_help
        exit
    ;;
    q)  # Get SQL query from parameter
        TAB=$OPTARG
        TAB_CONTENT=query
    ;;
    f)  # Get SQL query/queries from file
        echo ${OPTARG:0:1}
        if [ ${OPTARG:0:1} != '/' ]; then
            TAB=$(cat "$PWD/$OPTARG")
        else
            TAB=$(cat $OPTARG)
        fi
        TAB_CONTENT=queries
    ;;
    p)  # Specify psqlpath, when didn't specified it is get fro $PSQLPATH envirment variable
        PSQLPATH=$OPTARG
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Check contnet of $PSQLPATH
if [ "postgres://postgres:admin@172.17.0.2:5432/dianin" == '' ]; then
    echo  -e "\e[31mERROR:\e[0m   You need to specify PSQLPATH as your environmetn variable or via -p argument. To connect to given postgres database"
    exit
fi


# Create directory for storing generated websites in case there isn't one
if [ ! -d /tmp/pgprev ]; then
  mkdir -p /tmp/pgprev
fi

if [ $TAB_CONTENT == "none" ]; then
    TAB=$(echo '\dt' | psql $PSQLPATH | awk '{ print $3 }' | tail -n +4 | head -n -2)
fi

while read -r QUERY; do
    if [ $TAB_CONTENT == "none" ]; then
        QUERY="SELECT * FROM $QUERY;"
    fi
    printf "%s" "$STYLE" > /tmp/pgprev/"$QUERY".html
    echo "<h1><span class="ps">$</span>$QUERY</h1>" >> /tmp/pgprev/"$QUERY".html
    echo "$QUERY" | psql $PSQLPATH -H >> /tmp/pgprev/"$QUERY".html
    chromium /tmp/pgprev/"$QUERY".html > /dev/null 2>&1 &
    done <<< "$TAB"


# Why queries from file works while there is no ; in file
