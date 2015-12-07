<?php
   /* $q = $_GET["q"];
    $url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=".$q;
    $r = file_get_contents($url);
    $extract = explode('"extract":"',$r)[1];
    $extract = explode('"}',$extract)[0];
    if($extract==""){
        echo "<p class=\"info\">No results found \"$q\"</p>";
    }else{
        $extract = str_replace("\\\"",'"',$extract);
        $extract = "<p>".str_replace("\\n",'</p><p>',$extract)."</p>";
        echo $extract;
    }
	/*
?>

{
	"X":[
		{
			"name":"Kai",
			"freq":"4",
		},
		{
			"name":"Dog",
			"freq":"10",
		},
		{
			"name":"Fish",
			"freq":"3",
		}
	],
	"Y":[
		{
			"name":"Kai",
			"freq":"3",
		},
		{
			"name":"Dog",
			"freq":"11",
		},
		{
			"name":"Clown",
			"freq":"3",
		}
	],
}
