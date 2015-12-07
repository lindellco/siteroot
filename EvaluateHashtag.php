<?php
    $x = $_GET["x"];
	$y = $_GET["y"];
    $url = "http://hal2000.skip.chalmers.se:8000?x=".$x."&y=".$y;
    $r = file_get_contents($url);
	$r =  str_replace('\\"','"',$r);
	$r =  str_replace('""','"',$r);
	$r =  str_replace('["','[',$r);
	$r =  str_replace('"]',']',$r);
    echo $r;

/*
{
   "X":[
      {
         "tag":"Kai",
         "freq":"<?php echo(rand(0,40));?>"
      },
      {
         "tag":"Dog",
         "freq":"<?php echo(rand(0,40));?>"
      },
      {
         "tag":"Fish",
         "freq":"<?php echo(rand(0,40));?>"
      }
   ],
   "Y":[
		{
         "tag":"Fish",
         "freq":"<?php echo(rand(0,40));?>"
		},
      {
         "tag":"Kai",
         "freq":"<?php echo(rand(0,40));?>"
      },
      {
         "tag":"Dog",
         "freq":"<?php echo(rand(0,40));?>"
      },
      {
         "tag":"Clown",
         "freq":"<?php echo(rand(0,40));?>"
      }
   ]
}
*/
?>