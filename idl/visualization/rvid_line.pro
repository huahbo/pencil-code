pro rvid_line,field,mpeg=mpeg,tmin=tmin,tmax=tmax,max=amax,min=amin,$
  nrepeat=nrepeat,wait=wait,stride=stride,datadir=datadir,OLDFILE=OLDFILE,$
  test=test,proc=proc,exponential=exponential,map=map,tt=tt,noplot=noplot,$
  extension=extension, sqroot=sqroot, nocontour=nocontour,imgdir=imgdir, $
  squared=squared, exsquared=exsquared, against_time=against_time,func=func, $
  findmax=findmax, csection=csection,xrange=xrange, $
  transp=transp,global_scaling=global_scaling,nsmooth=nsmooth, $
  log=log,xgrid=xgrid,ygrid=ygrid,zgrid=zgrid,_extra=_extra,psym=psym, $
  xstyle=xstyle,ystyle=ystyle,fluct=fluct,newwindow=newwindow, xsize=xsize, $
  ysize=ysize,png_truecolor=png_truecolor, $
  xaxisscale=xaxisscale
;
; $Id$
;
;  Reads in 4 slices as they are generated by the pencil code.
;  The variable "field" can be changed. Default is 'lnrho'.
;
;  if the keyword /mpeg is given, the file movie.mpg is written.
;  tmin is the time after which data are written
;  nrepeat is the number of repeated images (to slow down movie)
;
;  Note:
;    proc=0 no longer works. Use datadir='data/proc0' instead.
;
;  Typical calling sequence
;  rvid_box,'bz',tmin=190,tmax=200,min=-.35,max=.35,/mpeg
;  rvid_line,'by',datadir='data/proc0',/xgrid
;  rvid_line,'XX_chiral',datadir='data/proc0',/xgrid,min=0,max=1
;
;
common pc_precision, zero, one
;
default,proc,-1
default,amax,.05
default,amin,-amax
default,field,'lnrho'
default,datadir,'data'
default,imgdir,'.'
default,nrepeat,0
default,stride,0
default,tmin,0.
default,tmax,1e38
default,wait,.03
default,extension,'xy'
default, xgrid, 0
default, ygrid, 0
default, zgrid, 0
default, psym, -2
;
if (keyword_set(png_truecolor)) then png=1
;
; if png's are requested don't open a window
;
if (not keyword_set(png)) then begin
  if (keyword_set(newwindow)) then begin
    window, /free, xsize=xsize, ysize=ysize, title=title
 endif
endif
;
if (proc ge 0) then begin
  procstr=strtrim(string(proc))
  procstr=strtrim(procstr)
  procstr='0'
  file_slice=datadir+'/proc'+procstr+'/slice_'+field+'.'+extension
endif else begin
  file_slice=datadir+'/slice_'+field+'.'+extension
endelse
print, file_slice
;;
;;  Read the dimensions and precision (single or double) from dim.dat
;;
pc_read_dim, obj=dim, datadir=datadir, /quiet
nx=dim.nx & ny=dim.ny & nz=dim.nz & prec=''
pc_set_precision, datadir=datadir
help, one
;
t=0.*one & islice=0
axz=fltarr(nx*ny)*one
slice_xpos=0.*one
slice_ypos=0.*one
slice_zpos=0.*one
slice_z2pos=0.*one
;
if (extension eq 'xy') then begin
  plane=fltarr(nx,ny)*one
endif else if (extension eq 'xz') then begin
  plane=fltarr(nx,nz)*one
endif else if (extension eq 'yz') then begin
  plane=fltarr(ny,nz)*one
endif
if (keyword_set(global_scaling)) then begin
  first=1L
  close,1 & openr,1,file_slice,/f77
  while (not eof(1)) do begin
    if (keyword_set(OLDFILE)) then begin ; For files without position
      readu,1,plane,t
    endif else begin
      readu,1,plane,t,slice_z2pos
    endelse
    if (keyword_set(exponential)) then begin
      if (first) then begin
        amax=exp(max(plane))
        amin=exp(min(plane))
        first=0L
      endif else begin
        amax=max([amax,exp(max(plane))])
        amin=min([amin,exp(min(plane))])
      endelse
    endif else if (keyword_set(sqroot)) then begin
      if (first) then begin
        amax=sqrt(max(plane))
        amin=sqrt(min(plane))
        first=0L
      endif else begin
        amax=max([amax,sqrt(max(plane))])
        amin=min([amin,sqrt(min(plane))])
      endelse
    endif else if (keyword_set(log)) then begin
      if (first) then begin
        amax=alog(max(plane))
        amin=alog(min(plane))
        first=0L
      endif else begin
        amax=max([amax,alog(max(plane))])
        amin=min([amin,alog(min(plane))])
      endelse
    endif else begin
      if (first) then begin
        amax=max(plane)
        amin=min(plane)
        first=0L
      endif else begin
        amax=max([amax,max(plane)])
        amin=min([amin,min(plane)])
      endelse
    endelse
  end
  close,1
  print,'Scale using global min, max: ', amin, amax
endif
;
;
;
pc_read_grid, object=grid, /trim
;
if (xgrid) then begin
  xaxisscale=grid.x
endif else if (ygrid) then begin
  xaxisscale=grid.y
endif else if (zgrid) then begin
  xaxisscale=grid.z
endif else begin
  xaxisscale=findgen(max([nx,ny,nz]))
endelse
;
;  open MPEG file, if keyword is set
;
dev='x' ;(default)
if (keyword_set(png)) then begin
  set_plot, 'z'                   ; switch to Z buffer
  device, SET_RESOLUTION=[!d.x_size,!d.y_size] ; set window size
  itpng=0 ;(image counter)
  dev='z'
endif else if (keyword_set(mpeg)) then begin
  ;Nwx=400 & Nwy=320
  Nwx=!d.x_size & Nwy=!d.y_size
  if (!d.name eq 'X') then window,2,xs=Nwx,ys=Nwy
  mpeg_name = 'movie.mpg'
  print,'write mpeg movie: ',mpeg_name
  mpegID = mpeg_open([Nwx,Nwy],FILENAME=mpeg_name)
  itmpeg=0 ;(image counter)
endif
;
;  allow for skipping "stride" time slices
;  initialize counter
;
istride=stride ;(make sure the first one is written)
;
it=0
close,1 & openr,1,file_slice,/f77
while (not eof(1)) do begin
  if (extension eq 'xy') then begin
    axz=fltarr(nx,ny)*one
  endif else if (extension eq 'xz') then begin
    axz=fltarr(nx,nz)*one
  endif else if (extension eq 'yz') then begin
    axz=fltarr(ny,nz)*one
  endif
;
  if (keyword_set(OLDFILE)) then begin ; For files without position
    readu,1,axz,t
  endif else begin
    readu,1,axz,t,slice_z2pos
  endelse
;
  if (keyword_set(transp)) then axz=transpose(axz)
  default,csection,((size(axz))[2]+1)/2
  axz=reform(axz)
  if (size(axz))[0] gt 1 then begin
    axz=reform(axz[*,csection])
  endif
  if (keyword_set(sqroot)) then axz=sqrt(axz)
  if (keyword_set(log)) then axz=alog(axz)
  if (keyword_set(squared)) then axz=axz^2
  if (keyword_set(exsquared)) then axz=exp(axz)^2
  if (keyword_set(nsmooth)) then axz=smooth(axz,nsmooth)
  if (keyword_set(fluct)) then axz=axz-mean(axz)
  if (keyword_set(func)) then begin
    value=axz
    res=execute('axz='+func,1)
  endif
;
  if (keyword_set(findmax)) then begin
    findshock,axz,xaxisscale,leftpnt=leftpnt,rightpnt=rightpnt
    if (it eq 0) then begin
      max_left=leftpnt
      max_right=rightpnt
    endif else begin
      max_left=[max_left, leftpnt]
      max_right=[max_right, rightpnt]
    endelse
  endif
;
  if (it eq 0) then tt=t else tt=[tt,t]
  if (it eq 0) then map=axz else map=[map,axz]
  it=it+1L
;
  if (keyword_set(test)) then begin
    if (not keyword_set(noplot)) then $
        print,t,min([axz,xy,xz,yz]),max([axz,xy,xz,yz])
  endif else begin
    if (t ge tmin and t le tmax) then begin
      if (istride eq stride) then begin
        if (not keyword_set(noplot)) then begin
          if (keyword_set(exponential)) then begin
            plot, xaxisscale, exp(axz), psym=psym, yrange=[amin,amax], $
                  xstyle=xstyle,ystyle=ystyle,xrange=xrange
          endif else begin
            plot, xaxisscale, axz, psym=psym, yrange=[amin,amax], _extra=_extra, $
                  xstyle=xstyle,ystyle=ystyle,xrange=xrange
          endelse
        endif
        if (keyword_set(png)) then begin
          istr2 = strtrim(string(itpng,'(I20.4)'),2) ;(only up to 9999 frames)
          image = tvrd()
;
;  make background white, and write png file
;
;          bad=where(image eq 0) & image(bad)=255
          tvlct, red, green, blue, /GET
          imgname = imgdir+'/img_'+istr2+'.png'
          write_png, imgname, image, red, green, blue
          itpng=itpng+1 ;(counter)
;
        endif else if (keyword_set(mpeg)) then begin
;
;  write directly mpeg file
;  for idl_5.5 and later this requires the mpeg license
;
          image = tvrd(true=1)
          for irepeat=0,nrepeat do begin
            mpeg_put, mpegID, window=2, FRAME=itmpeg, /ORDER
            itmpeg=itmpeg+1 ;(counter)
          end
          print,islice,itmpeg,t,min([axz]),max([axz])
        endif else begin
;
; default: output on the screen
;
          if (not keyword_set(noplot)) then print,islice,t,min([axz]),max([axz])
        endelse
        istride=0
        wait,wait
;
; check whether file has been written
;
        if (keyword_set(png)) then spawn,'ls -l '+imgname
;
      endif else begin
        istride=istride+1
      endelse
    endif
    islice=islice+1
  endelse
endwhile
close,1
;
;  write & close mpeg file
;
if (keyword_set(mpeg)) then begin
  print,'Writing MPEG file..'
  mpeg_save, mpegID, FILENAME=mpeg_name
  mpeg_close, mpegID
endif
;
;  reform map appropriately
;
nxz=n_elements(axz) & nt=it
map=reform(map,nxz,nt)
;
if (not keyword_set(nocontour)) then begin
  if (keyword_set(against_time)) then begin
    contour, transpose(exp(map)), tt, xaxisscale, /fill, nlev=60,ys=1,xs=1
  endif else begin
    contour, transpose(exp(map)), /fill, nlev=60,ys=1,xs=1
  endelse
endif
;
END
