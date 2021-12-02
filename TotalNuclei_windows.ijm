dir = getDir("Choose a Directory"); //user chooses what to name 
title = "Untitled";
width=600; height=600;
Dialog.create("Enter File Names");
Dialog.addString("Directory:", dir);
Dialog.addString("Save Total Nuclei Results As:", title); //user chooses what to name results
Dialog.show(); 
dir = Dialog.getString()
fileName = Dialog.getString();
//image size
width = getWidth; //gets width
height = getHeight; //gets height
getPixelSize(unit, pw, ph, pd); //gets pixel info
image_width = (width*pw)/1000; //converting image width from um to mm
image_height = (height*ph)/1000; //converting image height from um to mm
image_area = image_width*image_height; //image area


//begin analysis
width=600; height=600;
Dialog.create("Enter Multiplication Value");
Dialog.addNumber("Multiplication Value", 1);
Dialog.show(); 
multip = Dialog.getNumber();
run("Multiply...", "value=multip");
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Default dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
run("Close-"); 
run("Watershed");
run("Set Measurements...", "area add redirect=None decimal=0");
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
selectWindow("Results");
run("Close");
selectWindow("ROI Manager");
run("Close");
File.append(size, dir + fileName + ".csv");
File.append(mode_value, dir + fileName + ".csv");
File.append(image_area, dir + fileName + ".csv");

//calculations complete notification
Dialog.create("Message from Macro");
Dialog.addMessage("Calculations Complete!");
Dialog.show;
 
