<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<!-- $Id: tests_new.html,v 1.1 2013-06-18 21:36:54 illa Exp $ -->

<html>
<head>
  <meta name="language" content="en">
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <title>Pencil Code Tests</title>
  <link  rel="icon" href="pics/pencils_16x16.png">
  <link  rel=stylesheet href="pencil.css" type="text/css">
</head>

<body>

<h1>
    <img src="pics/pencils_65x30.png">
    &nbsp;&nbsp;&nbsp;
    Pencil Code &ndash; Tests
    &nbsp;&nbsp;&nbsp;
    <img src="pics/pencils_65x30.png">
</h1>

<h2>Automatic test results</h2>

<p>To ensure reproducability, the
<a href="http://www.nordita.org/software/pencil-code/">Pencil Code</a>
is tested daily for a number of
sample applications. This is important for us in order to make sure certain
improvements in some parts of the code do not affect the functionality
of other parts. For other users who suspect that a new problem has emerged
it could be useful to first see whether this problem also shows up in
our own tests. The latest test results for a can be seen online:</p>

<ul>
<!--
<li><a href="http://norlx50.albanova.se/~wdobler/pencil-code/tests/g95_debug.html">norlx50 (Linux, g95, by Wolfgang)</a>
-->
<!-- Anders Johansen test -->
<li><a href="http://www.astro.ku.dk/~ajohan/pencil-test.html">gfortran with open-mpi, quad-core with Intel Xeon 2.40 GHz cores, by Anders Johansen)</a></i>
<!-- Philippe Bourdin test -->
<li><a href="http://www.pab-software.de/Pencil/pc_auto-test.txt">GNU Fortran (Ubuntu 4.4.1-4ubuntu9) 4.4.1 (by Philippe Bourdin)</a></i>
<!-- Boris Dintrans test -->
<li><a href="http://www.ast.obs-mip.fr/users/dintrans/tmp/test_runs.html">Copernic (Linux/CentOS5 on 4 x Hexacore Intel Xeon E7540@2.00GHz, ifort 64 bits v12.0.1.107, by Boris Dintrans, regular level 2 test)</a></i>
<!-- Boris Dintrans test (2) -->
<li><a href="http://www.ast.obs-mip.fr/users/dintrans/tmp/our_tests.html">Copernic (Linux/CentOS5 on 4 x Hexacore Intel Xeon E7540@2.00GHz, ifort 64 bits v12.0.1.107, by Boris Dintrans, 16 separate tests)</a></i>
<!-- Weekly (big) test -->
<li><a href="http://www.svenbingert.de/auto-test.html">Linux/Ubuntu10.4 on Intel Core 2 Quad Q9000@2.00GHz, ifort 64bit v11.1 (Sven Bingert, standard + personal tests)</a></i>
<li><a href="http://norlx51.albanova.se/~brandenb/pencil-code/tests/g95_debug.html">Nordita Big Test (norlx51, gfortran, openmpi, by Wolfgang/Axel)</a></i>
<!-- Weekly (big) test -->
<li><a href="http://norlx51.albanova.se/~brandenb/pencil-code/tests/gfortran_hourly.html">Nordita Hourly Test (norlx51, gfortran, openmpi, by Wolfgang/Axel)</a></i>
<!--
<li><a href="http://www.nordita.org/~brandenb/pencil-code/normac.html">Nordita Mac Mini (os10, g95, lammpi, by Axel)</a>
[<a href="http://www.nordita.org/~brandenb/pencil-code/normac_previous.html">previous</a>]
<li><a href="http://www.nordita.org/~brandenb/pencil-code/nor52.html">Nordita PowerMac (os10, g95, ompi, by Axel)</a>
[<a href="http://www.nordita.org/~brandenb/pencil-code/nor52_previous.html">previous</a>]
-->
<!-- Nordita PowerMac -->
<li><a href="http://norlx51.albanova.se/~brandenb/pencil-code/tests/nor52.html">Nordita PowerMac (os10, g95, ompi, by Axel)</a>
[<a href="http://norlx51.albanova.se/~brandenb/pencil-code/tests/nor52_previous.html">previous</a>]</i>
<!--
<li><a href="http://www.nordita.org/~brandenb/pencil-code/qmul.html">Queen Mary Cluster (London, by Axel)</a>
[<a href="http://www.nordita.org/~brandenb/pencil-code/qmul_previous.html">previous</a>]
<li><a href="http://www.nordita.org/~brandenb/pencil-code/fend.html">DCSC cluster in Copenhagen (pgf90 -fastsse -tp k8-64e, by Axel)</a>
[<a href="http://www.nordita.org/~brandenb/pencil-code/fend_previous.html">previous</a>]
<li><a href="http://www.capca.ucalgary.ca/~theine/pencil-code/dcsc.html">Horseshoe (Linux cluster, ifc 6.0 compiler, by Tobi)</a>
<li><a href="http://www.astro.ku.dk/~ajohan/pencil-code/dcsc.html">Horseshoe (Linux cluster, ifort compiler, by Anders)</a>
<li><a href="http://www.astro.ku.dk/~ajohan/pencil-code/aida25.html">aida25 (Linux cluster, ifort compiler with MPICH, by Anders)</a>
<li><a href="http://bohr.phys.ntnu.no/~nilshau/pencil-code/gridur.html">Gridur (SGI machine in Trondheim, by Nils)</a>
<li><a href="http://www.tac.dk/~brandenb/pencil-code/tac.html">tacsg2 (SGI machine, always some problems...)</a>
-->
</ul>

<p>Note: before checking in your own changes, you should at least do
the very minimal auto-test:</p>

<p><code>
  pc_auto-test --level=0 --no-pencil-check -C
</code></p>

<h2>Results from tests</h2>



<h3><tt>samples/1d-tests</tt></h3>

<ul>
<li><i>Sod shock tube tests</i> (checked in under samples/1d-tests/sod_10
to sod_1000). Initial condition is a smoothed (width=0.03) isothermal
pressure jump ranging from 10:1 to 1000:1.
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th> pressure jump 10:1 </th>
    <th> pressure jump 100:1 </th>
    <th> pressure jump 1000:1 </th>
  </tr>
  <tr>
    <td align=center> <A href="samples/1d-tests/sod_10.png"><img src="samples/1d-tests/sod_10_thumb.jpg"></a> </td>
    <td align=center> <A href="samples/1d-tests/sod_100.png"><img src="samples/1d-tests/sod_100_thumb.jpg"></a> </td>
    <td align=center> <A href="samples/1d-tests/sod_1000.png"><img src="samples/1d-tests/sod_1000_thumb.jpg"></a> </td>
  </tr>
  <tr>
    <td> &nu;=.02, &chi;=.0005, <i>t</i>=2.7: </td>
    <td> &nu;=.04, &chi;=.0005, <i>t</i>=1.9: </td>
    <td> &nu;=.08, &chi;=.0005, <i>t</i>=1.5: </td>
  </tr>
</table>
</div>
The values of viscosity are chosen rather conservatively;
for weak shocks one can get away with less viscosity
(<A href="samples/1d-tests/sod_10_nu0.014.png">&nu;=.014 for 10:1</a> and
<A href="samples/1d-tests/sod_100_nu0.028.png">&nu;=.028 for 100:1</a>).
For strong shocks (pressure jumps of 1000:1 and above) the
discrepancy compared with the inviscid analytic solution
becomes quite noticeable.</li>

<li><i>Rarefaction shocks</i> (checked in under samples/1d-tests/expans,
expans_bfield and riemann_bfield).
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th>no B-field</th>
    <th>with B-field</th>
    <th>shock with B-field</th>
  </tr>
  <tr>
    <td align=center> <A href="samples/1d-tests/expans.png"><img src="samples/1d-tests/expans_thumb.jpg"></a> </td>
    <td align=center> <A href="samples/1d-tests/expans_bfield.png"><img src="samples/1d-tests/expans_bfield_thumb.jpg"></a> </td>
    <td align=center> <A href="samples/1d-tests/riemann_bfield.png"><img src="samples/1d-tests/riemann_bfield_thumb.jpg"></a> </td>
  </tr>
  <tr>
    <td>cf. Fig. 1 of <A href="http://xxx.lanl.gov/abs/astro-ph/0207419">Falle (2002)</a></td>
    <td>cf. Fig. 2 of <A href="http://xxx.lanl.gov/abs/astro-ph/0207419">Falle (2002)</a></td>
    <td>cf. Fig. 6 of <A href="http://xxx.lanl.gov/abs/astro-ph/0207419">Falle (2002)</a></td>
  </tr>
</table>
</div></li>

<li>Conditions for non-magnetic rarefaction shock.
<i>Left state</i>: &rho;=1, p=10, ux=-3.
<i>Right state</i>: &rho;=.87469, p=8, ux=-2.46537.
This corresponds to s/cp=1.68805 on both sides. 800 points.
&nu;=0.05, &chi;=0.0002.</li>

<li>Conditions for magnetic rarefaction shock.
<i>Left state</i>: &rho;=1, p=.2327, ux=-4.6985, uy=-1.085146, Bx=-0.7, By=1.9680.
<i>Right state</i>: &rho;=.7270, p=.1368, ux=-4.0577, uy=-0.8349, Bx=-0.7, By=1.355.
This corresponds to s/cp=-0.5682 on both sides. 800 points.
&nu;=&chi;=&eta;=0.07.</li>

<li>Conditions for magnetic Riemann problem.
<i>Left state</i>: &rho;=0.5, p=10, ux=0, uy=2, Bx=2, By=2.5.
<i>Right state</i>: &rho;=0.1, p=0.1, ux=-10, uy=0, Bx=2, By=2.
This corresponds to s/cp=2.38119 on the left and 1.22753 on the right. 800 points.
&nu;=&chi;=&eta;=2.</li>

<li><i>Note</i>: in the tests above, uniform viscosity is used.  The
viscosity has to be chosen such as to cope with the strongest
compression in the domain. By using
a <a href="samples/1d-tests/visc_shock"> nonuniform (artificial)
viscosity</a>, both compression and expansion shocks can be made as
sharp as possible.</li>
</ul>



<h3><tt>samples/conv-slab-2d</tt></h3>

<p>Vertical cross-section at <i>t</i>=920: K=0.008, &nu;=0.004</p>

<ul>
<li><i>2-D convection</i> (checked in under
samples/2d-tests/conv-slab-2d and conv-slab-2d2).
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th>no B-field</th>
    <th>with B-field</th>
  </tr>
  <tr>
    <td align=center> <A href="samples/2d-tests/conv-slab-2d.gif"><img src="samples/2d-tests/conv-slab-2d_thumb.jpg"></a> </td>
    <td align=center> <A href="samples/2d-tests/conv-slab-2d2.gif"><img src="samples/2d-tests/conv-slab-2d2_thumb.jpg"></a> </td>
  </tr>
  <tr>
    <td>(<i>t</i>=920)</td>
    <td>(<i>t</i>=320)</td>
  </tr>
</table>
</div>
</li>

<li><i>2-D convection</i> (checked in under samples/2d-tests/A3+chi11+Ra1e5).
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th>aspect ratio 3, density ratio 11, Ra=10<sup>5</sup></th>
  </tr>
  <tr>
    <td align=center> <A href="samples/2d-tests/A3+chi11+Ra1e5.png"><img src="samples/2d-tests/A3+chi11+Ra1e5_thumb.jpg"></a> </td>
  </tr>
  <tr>
    <td>(<i>t</i>=530, K=&nu;=0.0011, 150x51 points)</td>
  </tr>
</table>
</div>
</li>
</ul>



<h3><tt>samples/turbulence/helical-MHDturb32-4procs</tt></h3>

<p>Low resolution helical MHD turbulence run, 2x2 processors,
initial field: random
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th>t=200-1700</th>
    <th>t=200-800</th>
    <th>initial field: Beltrami</th>
  </tr>
  <tr>
  <td align=center> <a href="samples/turbulence/helical-MHDturb32-4procs/bz_till1700.mpg"><img src="samples/turbulence/helical-MHDturb32-4procs/bz_thumb.jpg"></a></td>
  <td align=center> <a href="samples/turbulence/helical-MHDturb32-4procs/bz_till800.mpg"><img src="samples/turbulence/helical-MHDturb32-4procs/bz_thumb.jpg"></a></td>
  <td align=center> <a href="samples/turbulence/rot512_Om0a/I8_0-37.mpg"><img src="samples/turbulence/rot512_Om0a/img_0000_thumb.jpg"></a></td>
  </tr>
  <tr>
    <td align=center>full sequence(7.3Mb)</td>
    <td align=center>every 2nd frame (1.4Mb)</td>
    <td align=center>hires run: 512<sup>3</sup> (1.1Mb)<br>rot512_Om0a</td>
  </tr>
</table>
</div>
</p>

<h3><tt>samples/turbulence/hydro512f</tt></h3>

<p>A non-helical hydro turbulence run, 512<sup>3</sup> meshpoints, 128 processors
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th></th>
    <th></th>
    <th></th>
  </tr>
  <tr>
  <td align=center> <a href="samples/turbulence/hydro512f/uz_0-131.mpg"><img src="samples/turbulence/hydro512f/uz_thumb.jpg"></a></td>
  <td align=center> <a href="samples/turbulence/hydro512f/uz_0-148.mpg"><img src="samples/turbulence/hydro512f/uz_thumb2.jpg"></a></td>
  <td align=center> <a href="samples/turbulence/hydro512f/lnrho_0-148.mpg"><img src="samples/turbulence/hydro512f/lnrho_thumb.jpg"></a></td>
  </tr>
  <tr>
    <td align=center>z-comp of velocity (4.7Mb)<br>t=500-565</td>
    <td align=center>z-comp of velocity (6.4Mb)<br>t=566-640</td>
    <td align=center>log of density: lnrho (4.1Mb)<br>t=566-640</td>
  </tr>
</table>
</div>
</p>



<h3><tt>samples/shearing-box/BH256_3D_mean_Bz=0b1</tt></h3>

<p>Shearing box simulation, 256<sup>3</sup> meshpoints, 32 processors
<div align=center>
<table border=0 cellspacing=15>
  <tr>
    <th></th>
  </tr>
  <tr>
  <td align=center> <a href="samples/shearing-box/BH256_3D_mean_Bz=0b1.mpg"><img src="samples/shearing-box/BH256_3D_mean_Bz=0b1_thumb.jpg"></a></td>
  </tr>
  <tr>
    <td align=center>z-comp of velocity (2.8Mb)<br>t=296-393</td>
  </tr>
</table>
</div>
</p>


<!-- <h3><tt>samples/interlocked-fluxrings</tt></h3> -->

<!-- <p>Time evolution up to <i>t</i>=1.0: -->
<!-- <div align=center> -->
<!--   <img src="pics/pencils_65x30.png"> -->
<!-- </div></p> -->

<!-- <p>Isosurface of |<b>B</b>| at <i>t</i>=1.0: -->
<!-- <div align=center> -->
<!--   <img src="pics/pencils_65x30.png"> -->
<!-- </div></p> -->


<hr>
<small>
<!-- hhmts start -->
$Date: 2013-06-18 21:36:54 $
<!-- hhmts end -->
</small>
</body>
</html>