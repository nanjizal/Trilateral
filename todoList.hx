TODO and Problems.

1) SEEMS A LOT BETTER NOW... is it fixed??
'Fine' path drawing class is currently not working because 'Contour' does not have angle guards that justTriangle did.
The problem seems to show when crossing zero in a sine wave, probably need the corner curve code to be limited when an angle is near 0.

2)
justPath x and y offset for paths may not work for some curve data?

3)
justTriangle had code related to scaling that was very useful but clunky need to rethink I have already added something so you can check sizes of drawing after drawing.

4) 
Need to check justTriangle for shapes that are not supported.

5) 
Add DroidSans svg path example?

6)
Add generic star.

7) DONE
Remove Point from Circle or shapes prefer generally to minimize use of Point it will only add overhead.

8)
Need to see if it still works on Kha graphics2 and perhaps graphics4

9)
I am not sure if polytrihx is better than hxDaedalus for fills. PolyK has an isSimple it is what is used in justTriangle it's not good at complex shapes, but maybe fast for simple so need to build and test.  I have improved hxDaedalus see heaps and Kha examples they use simple triangle approach for drawing.

10) DONE
Need to re-enable the overlap in the triangleJoin as an option since it is less likely to fail and is probably lighter than separate lines with rounded corners on the end which is currently my best option.

11) 
The drawing currently draws shapes incase they are the last and then throws them away this can't really be helped but perhaps could reuse them, also could add a feature so when passing fixed length it only draws last.

12) 
The pie and arc code is currently not correct from my 'fracs' library seem to be 0 pointing down and clockwise is anti-clockwise, this maybe the reason some -theta-Math.PI is in the Contour class it may need me to change all the triangles :( so that clockwise makes sense but a lot of work just so that the rounded corners code is more logical. Part of the problems where down to me developing with scales all wrong much better now with more flash like scales.
    
13)
Need to check that bitmap is easy to do have demo of concept in my repo but quite a bit of webgl changes for it.

14)
Need to wire up a demo of the linear gradient code, example also in my repo

15)
Circular gradients... not sure have researched this problem is getting lots of colors into shaders could try to build like linear but then would need hollow strips complex lot of work unlikely to make into any stable release.

16)
The id of triangles is used for hitTest see the tetris example in my repository need to wire up an example.

17)
The width equations is quite nice but only works with thin lines as you can see the steps when width is thick this could be problematic may require rethink.

18)
Straight lines need to be split up similar to curves when using a width equation

19)
Width equation needs to be implemented on arc.

20) DONE
Need to implement a roundedRectangle outline same as current one just use arc rather than pie. Low Friut :)

21) 
Need arrows as they are always useful.

22) 
steal equalateral triangle from justTriangle this is so useful with rotation for arrows but may need changing.

23)
Would like to look at letters and see if some of the drawing letters on a path car be ported but very complex code I can't remember how it really worked!

24)
Need to build a drawing app with history so I can test stuff easier and make sure it has all needed.

25)
Still unsure on colorID is it better just to save the color but then that's not so good for gradient and images.

26)
Need to look at SixteenSeg it seems to really slow down compile etc... think I may have overdone inlines but also need to move over other segment drawing stuff... should it be in another repo.

27)
Move angle stuff over from fracs do I keep fraction with it?

