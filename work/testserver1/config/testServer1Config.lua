local config
config =
{
    testServer1 =
    {
        port = 9020,
        debugPort = 9930,
    },
    mysql = 
    {
        testmysql1 = 
        {
            host = "127.0.0.1",
            port = 3306,
            user = "root",
            password = "*****",
            database = "test",
        }
    },
    redis = 
    {
        testredis1 = 
        {
            host = "127.0.0.1",
            port = 6379,
            auth = "****@sf",
        }
    },
}

return config
