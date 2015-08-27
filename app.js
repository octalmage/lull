/*  _          _ _ 
 * | |   _   _| | |
 * | |  | | | | | |
 * | |__| |_| | | |
 * |_____\__,_|_|_|
 * By: Jason Stallings
 */
 
var robot = require("robotjs");
var gui = require("nw.gui");
var async = require("async");
var loudness = require("loudness");
var appVersion = gui.App.manifest.version;

var win = gui.Window.get();

//Height of Hulu's black ad bar.
var adHeight = 45;

//Create tray.
var tray = new gui.Tray(
{
	title: "Lull"
});

//Give it a menu.
var menu = new gui.Menu();
menu.append(new gui.MenuItem(
{
	label: "v" + appVersion
}));

menu.append(new gui.MenuItem(
{
	type: "separator"
}));
menu.append(new gui.MenuItem(
{
	label: "Exit",
	click: function()
	{
		gui.App.quit();
	},
}));
tray.menu = menu;

//App Start.
scan();
setInterval(scan, 1000);

//Check to see if ad is playing using screen reading.
function scan()
{
	//Array of tasks for async parallel. 
	var tasks = [];
	
	//Check every 5 pixels for black.
	for (var x = 0; x < adHeight; x += 5)
	{
		//Closure to keep value of x.
		(function(x) 
		{
			tasks.push(function(done)
			{
				var hex = robot.getPixelColor(0, x);
				
				//If hex is 000000, return true.
				var pass = hex === "000000" ? true : false;
				done(null, pass);
			});
		}(x));
	}
	
	//Special check, make sure ad text is displaying.
	tasks.push(function(done)
	{
		var hex = robot.getPixelColor(25, 22);
		
		//If hex is ededed, return true.
		var pass = hex === "ededed" ? true : false;
		done(null, pass);
	});
	
	async.parallel(tasks, function(err, results)
	{
		//If false isn't found, ad must be playing.
		if (results.indexOf(false) == -1)
		{
			//If not muted, mute it!
			loudness.getMuted(function (err, mute) 
			{
				if (!mute)
				{
					loudness.setMuted(true, function(err) {});
				}
			});
		}
		else 
		{
			//If muted, unmute it!
			loudness.getMuted(function (err, mute) 
			{
				if (mute)
				{
					loudness.setMuted(false, function(err) {});
				}
			});
		}
	});
}