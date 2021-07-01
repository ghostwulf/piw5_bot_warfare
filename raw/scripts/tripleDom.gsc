#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	setDvarIfUninitialized( "dom_lastFlagUseTimeMulti", 1.0 );

	thread watchFlags();
}

watchFlags()
{
	if ( getDvar( "g_gametype" ) != "dom" )
		return;

	while ( !isDefined( level.flags ) )
		wait 0.05;

	for ( ;; )
	{
		wait 1;

		for ( i = 0; i < level.flags.size; i++ )
		{
			flag = level.flags[i];

			if ( isDefined( flag.originalUseTime ) )
			{
				flag.useTime = flag.originalUseTime;
				flag.originalUseTime = undefined;
			}
		}

		team = "none";

		axisFlags = maps\mp\gametypes\dom::getTeamFlagCount( "axis" );
		alliesFlags = maps\mp\gametypes\dom::getTeamFlagCount( "allies" );

		if ( alliesFlags == 2 || axisFlags == 2 )
		{
			if ( alliesFlags == 2 )
				team = "allies";
			else
				team = "axis";
		}

		if ( team != "none" )
		{
			for ( i = 0; i < level.flags.size; i++ )
			{
				flag = level.flags[i];

				flagTeam = flag maps\mp\gametypes\_gameobjects::getOwnerTeam();

				if ( flagTeam != team && ( flagTeam == "axis" || flagTeam == "allies" ) )
				{
					flag.originalUseTime = flag.useTime;
					flag.useTime *= getDvarFloat( "dom_lastFlagUseTimeMulti" );
				}
			}
		}
	}
}
