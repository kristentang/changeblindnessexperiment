# Change Blindness Experiment

Psychology 20B: Advanced Topics in MATLAB Programming for Behavioral Sciences \
Professor Uri Maoz\
Final Project with Jenna Leland, Shawn Schwartz, and Yasha Mouradi\
June 2017

Change blindness is the perceptual phenomenon of not noticing a change in a visual stimulus. A common example of this phenomenon is when an observer overlooks a major difference in two versions of the same image as it rapidly alternates between the two. In this experiment, we wanted to study how they type of stimuli and it's distance from an observer's gaze would affect the observer's accuracy and response time in finding a changing stimuli. We were interested in knowing if the percieved salience of certain aspects of an image would distract the observer from catching a change in the stimuli. 

<img src = "https://kristentang.github.io/photos/changeblind.gif">

## Design 
### Independent Variables: 
1. Stimuli Type (Realistic images or random shapes)
2. Target-gaze proximity (Immediately prior to each trial, participants performed a mouse trace task, which created a controlled gaze location at the start of the trial. Target-gaze proximity was measure in distance from the last location of the mouse trace task to location of the change in the stimuli) 

For realistic image trials, photos were taken from a database of images used to test the change blindness phenomenon. We calculated the size and location of the change, and made a corresponding random shape trial whose changing shape was the same size and located at the same place. 
<img src = "https://kristentang.github.io/photos/changeblind1.jpg">
To make a trial, the two images were flashed 10 times each. Images were alternatingly flashed for 0.4 seconds, with a blank screen flashed for 0.2 seconds in between.

### Dependent Variables: 
1. Accuracy (% hits)
2. Response Time 

## Hypotheses: 
1. The smaller the target-gaze proximity, the faster and more accurately participants will find the change in the stimuli. 
2. Participants will find changes faster and more accurately in shapes than in images. 

## Methods
This experiment was made using MATLAB. More detailed explanations of the experiment can be found in "CB_Exp_Presentation.pdf" and the experiment itself is in the "CB_Exp" folder. 

## Results 
<img src = "https://kristentang.github.io/photos/changeblind2.jpg" width = 45%><img src = "https://kristentang.github.io/photos/changeblind22.jpg" width = 45%>

Results showed that it was easier for participants to detect a change in the generated images or the photo. 


<img src = "https://kristentang.github.io/photos/changeblind3.jpg" width = 45%><img src = "https://kristentang.github.io/photos/changeblind4.jpg" width = 45%>
<img src = "https://kristentang.github.io/photos/changeblind5.jpg" width = 45%>

Results showed a greater accuracy in trials with random shapes than images, as well as a faster mean reaction time of hits the closer the changing stimuli was to the final location of the target practice. 




