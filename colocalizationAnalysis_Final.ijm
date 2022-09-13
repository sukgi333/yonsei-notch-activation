function colocJacop(input, output, filename) {	
	open(input+filename);

	run("Split Channels");
	selectImage(1); 
	green = getTitle(); 
	selectImage(2); 
	blue = getTitle();

	selectWindow(green);
	run("Subtract Background...", "rolling=12 stack");
	run("Median...", "radius=1 stack");
	run("Z Project...", "projection=[Max Intensity]");
	run("Grays");
	setAutoThreshold("Otsu dark");
	getThreshold(lower1,upper1);

	selectWindow(blue);
	run("Subtract Background...", "rolling=12 stack");
	run("Median...", "radius=1 stack");
	run("Z Project...", "projection=[Max Intensity]");
	run("Grays");
	setAutoThreshold("Otsu dark");
	getThreshold(lower2,upper2);

	run("JACoP ", "imga=[" + green + "] imgb=[" + blue + "] thra=" + lower1 + " thrb=" + lower2 +" pearson mm costesthr ccf=20");
	selectWindow("Log");  //select Log-window 
	saveAs("Text", output + filename);
	"\\Clear"

	selectWindow("Van Steensel's CCF between "+green+" and "+blue);
	Plot.getValues(x, y);
	for (j=0; j<x.length; j++){
		print(x[j], ",", y[j]);
	}
	name = "CrossCorrResults_"+ filename + ".csv"; 
	dir_name = output + name;

	selectWindow("Log");  
	saveAs("Text", dir_name); 
	run("Close All");
	"\\Clear"
}

input =  "/Users/minsuk/Notch_Image_Analysis/MOC_PS1-hN1-Dll/2021-07-31/DAPT wash-out/MOC_PS1-hN1/";
output =  "/Users/minsuk/Notch_Image_Analysis/MOC_PS1-hN1-Dll/2021-07-31/DAPT wash-out/MOC_PS1-hN1_result/";

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        colocJacop(input, output, list[i]);
setBatchMode(false);