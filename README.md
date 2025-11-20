[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/stringart)

📌 Overview
This repository provides the MATLAB function stringart, which generates classic "string art" (pin and thread art) patterns on regular polygons. By connecting points along the sides or angle bisectors of a polygon, the function creates visually smooth curves built from straight line segments.

![](https://github.com/dnafinder/stringart/blob/master/stringart.png)

✨ Features
The function draws string-art patterns on regular polygons with a configurable number of sides. It supports dense pin placement for smooth envelopes, optional crossed connections for richer geometric structures, customizable RGB colors, and an optional animation mode that progressively reveals the pattern. The latest version of the code is available exclusively on GitHub.

🛠 Installation
Download or clone this repository from GitHub:
https://github.com/dnafinder/stringart

Add the folder containing stringart.m to your MATLAB path using the Add Folder to Path option or the addpath command. No additional toolboxes are required; the function relies only on core MATLAB graphics.

▶️ Usage
Call the function from the MATLAB command window, a script, or a live script. You can either accept default settings or customize the pattern using Name-Value pairs. Optionally, you can capture the handles to the plotted line objects for further styling.

For example:
stringart
stringart('Sides', 5, 'Crossed', true, 'Density', 80, 'Color', [0 0.4 0.8])
h = stringart('Sides', 6, 'Crossed', false, 'Density', 60, 'Color', [0.8 0 0], 'Animate', true)

🎛 Inputs
The function uses Name-Value pairs:

'Sides'   : Positive integer greater than or equal to 3. It controls the number of sides of the regular polygon used to place the pins. The default value is 3 (an equilateral triangle).

'Crossed' : Logical or 0/1 flag. When false (0), the function connects pins along polygon edges, producing a pattern that follows each side. When true (1), the function connects pins across angle bisectors, creating crossed chords and a different style of envelope. The default is false.

'Density' : Positive integer specifying how many pins are placed along each side. Larger values generate more segments and smoother curves but increase the computational cost and plotting time. The minimum allowed value is 10, and the default is 40.

'Color'   : 1-by-3 numeric row vector with values in the interval [0 1]. It defines the RGB color of the string-art segments. The default color is [0 0 0], which corresponds to black.

'Animate' : Logical or 0/1 flag controlling whether the pattern is drawn progressively. When false (0), all line segments are drawn as quickly as possible. When true (1), the figure is updated after each segment, producing a simple animation. The default is false.

📤 Outputs
h = stringart(...) returns a column vector of line object handles, one for each drawn segment. You can use these handles to modify properties such as LineWidth, LineStyle, and Color after the pattern has been generated.

If you do not request an output, the function simply draws the pattern in the current axes and does not return any variable.

🔍 Interpretation
The patterns produced by stringart visually approximate quadratic Bézier curves using only straight line segments. As the number of pins per side increases, the envelope formed by the segment intersections closely resembles smooth mathematical curves. Varying the number of sides, the crossed flag, and the density leads to a wide variety of geometric and artistic designs.

📝 Notes
For dense patterns or large figures, disabling animation (Animate = false) is recommended to keep the drawing responsive. You can embed stringart in subplots or combine it with other graphics by preparing axes before calling the function. The function uses only basic MATLAB graphics and should work across many MATLAB releases that support inputParser and modern graphics handles.

📚 Citation
If you use this code in scientific, educational, or technical work, please cite it as:

Cardillo G. (2018)
"Stringart: Play with geometry and Bézier's quadratic curve".
Available from GitHub:
https://github.com/dnafinder/REPOSITORY_NAME

👤 Author
Author: Giuseppe Cardillo
Email: giuseppe.cardillo-edta@poste.it
GitHub: https://github.com/dnafinder/REPOSITORY_NAME

⚖️ License
This project is distributed under the MIT License. You are free to use, modify, and redistribute the code, provided that the original copyright notice and license text are preserved. The full license terms are provided in the LICENSE file in this GitHub repository.
