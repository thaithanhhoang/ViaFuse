//setup
dir = getDir("Choose a Directory"); //user chooses what to name 
title = "Untitled";
width=600; height=600;
Dialog.create("Enter File Names");
Dialog.addString("Directory:", dir);
Dialog.addString("Save Fusion Index Results As:", title); //user chooses what to name results
Dialog.show(); 
dir = Dialog.getString()
fileName = Dialog.getString();

//number of slices a stack has
if (nSlices == 3) {
	dapi_channel = 3; 
	myh_channel = 1; 
}

if (nSlices == 4) {
	dapi_channel = 4;
	myh_channel = 2; 
}

//begin analysis
width=600; height=600;
Dialog.create("Enter Multiplication Value");
Dialog.addNumber("Nuclei Multiplication Value", 1);
Dialog.addNumber("Myotube Multiplication Value", 1);
Dialog.show(); 
multip1 = Dialog.getNumber();
multip2 = Dialog.getNumber();
setSlice(dapi);
dapi = getInfo("slice.label");
run("Multiply...", "value=multip1");
setSlice(myh_channel);
myh = getInfo("slice.label");
run("Multiply...", "value=multip2");

run("Stack to Images");
selectWindow(dapi);
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Default dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
run("Close-"); 
run("Watershed");

selectWindow(myh);
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Default dark");
setOption("BlackBackground", false);
run("Convert to Mask");
//setThreshold(255, 255);
run("Convert to Mask");
run("Close-");
run("Median...", "radius=1");

//image subtraction 
selectWindow(dapi);
imageCalculator("Subtract create", dapi, myh);

run("Set Measurements...", "area add redirect=None decimal=0");
selectWindow("Result of " + dapi);
run("Analyze Particles...", "size=50-250 display exclude add");
//number of particles
size = nResults;
//Mode of "Area" column
mode_value=0;
max_Count=0;
for (i=0; i<nResults(); i++) {
	count = 0;
	for (j = 0; j<nResults(); j++) {
		if (d2s(getResult("Area",i),0) == d2s(getResult("Area",j),0)) {
		count++;
		}
	}
	if (count > max_Count) {
		max_Count = count;
		mode_value = d2s(getResult("Area", i),0);
	}
}
selectWindow("Results");
run("Close");
selectWindow("ROI Manager");
run("Close");
run("Analyze Particles...", "size=251-Infinity display exclude add");
saveAs("Results", dir + fileName + ".csv");
run("Close");
File.append(size, dir + fileName + ".csv");
File.append(mode_value, dir + fileName + ".csv");

//Saving Image
selectWindow("Result of " + dapi);
run("Red");
rename("dapi_final");
selectWindow(myh);
run("Green");
rename("myh_final");
run("Merge Channels...", "c1=[dapi_final] c2=myh_final create");
saveAs("PNG", dir + fileName + ".png");

//calculations complete notification
Dialog.create("Message from Macro");
Dialog.addMessage("Calculations Complete!");
Dialog.show;
 
