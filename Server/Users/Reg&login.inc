stock GetPlayerSalt(name[])
{
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

stock AttemptLogin(playerid, password[])
{
	new hash[256] = "";
	SHA256_PassHash(password, GetPlayerSalt(player_name), hash, sizeof(hash));
	
	if(hash == player_password[playerid]) return 1;
	return 0;
}
