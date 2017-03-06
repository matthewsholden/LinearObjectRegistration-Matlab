%Run the linear object registration for all the fCal and lumbar data

noise = 1.5;

% % fCal
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18_Recording1.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18_Recording2.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry18_Recording3.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27_Recording4.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27_Recording5.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry27_Recording6.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36_Recording7.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36_Recording8.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry36_Recording9.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45_Recording10.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45_Recording11.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\fCal\PhantomfCal1.2_Geometry45_Recording12.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% 
% %Lumbar
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15_Recording1.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15_Recording2.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry15_Recording3.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24_Recording4.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24_Recording5.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry24_Recording6.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36_Recording7.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36_Recording8.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Nov22_2013\Lumbar\PhantomLumbar_Geometry36_Recording9.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% % LEGO
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18_Recording1.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18_Recording2.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry18_Recording3.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27_Recording4.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27_Recording5.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry27_Recording6.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36_Recording7.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36_Recording8.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry36_Recording9.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45_Recording10.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45_Recording11.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )
% 
% geometryFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45.xml';
% recordFile = 'S:\data\LinearObjectRegistration\Feb21_2014\Lego\PhantomLego_Geometry45_Recording12.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )


% Gel Block

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15_Recording1_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15_Recording2_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15_Recording3_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26_Recording4_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26_Recording5_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry26_Recording6_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37_Recording7_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37_Recording8_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37.xml';
recordFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry37_Recording9_Cut.xml';
LinearObjectRegistration( geometryFile, recordFile, noise )

% geometryFile = 'S:\data\LinearObjectRegistration\May29_2014\GelBlock\PhantomGelBlock_Geometry15.xml';
% recordFile = 'F:\Jun13_2014\GelBlock\PhantomGelBlock_Geometry15_Recording1.xml';
% LinearObjectRegistration( geometryFile, recordFile, noise )