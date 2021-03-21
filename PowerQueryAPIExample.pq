/*
    Edit Data Source Settings to be approriate security. 
*/
let
    //Variables - Update 
    app_id = "<appid>",
    app_key = "<appkey>",

    serverurl = "https://<server address>",

    token_uri = serverurl & "/auth/connect/token",
    peme_uri = serverurl & "/PE/api/StaffMember/Me", 

    //Basic Auth - convert to Base64
    BasicAuth = "Basic " & Binary.ToText(Text.ToBinary(app_id & ":" & app_key),0),
    

    //Token
    GetTokenRequestJson = Web.Contents(token_uri, 
        [
            Headers = [#"Authorization"=BasicAuth,
                       #"Content-Type"="application/x-www-form-urlencoded"
            ],
            Content = Text.ToBinary(Uri.BuildQueryString(
                [
                    grant_type = "client_credentials",
                    scope = "pe.api"
                ]
            ))
        ]
    ),
    FormatTokenRequestJson = Json.Document(GetTokenRequestJson),
    AccessToken = FormatTokenRequestJson[access_token],

    BearerTokenHeader = "Bearer " & AccessToken,

    GetPEJsonQuery = Web.Contents(peme_uri,
        [
            Headers = [#"Authorization"=BearerTokenHeader]
        ]
    ),
    FormatPEJsonQuery = Json.Document(GetPEJsonQuery)
    
in
    FormatPeJsonQuery