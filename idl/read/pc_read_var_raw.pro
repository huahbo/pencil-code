; +
; NAME:
;       PC_READ_VAR_RAW
;
; PURPOSE:
;       Read var.dat, or other VAR files in an efficient way!
;
;       Returns one array from a snapshot (var) file generated by a
;       Pencil Code run, and another array with the variable labels.
;       Works for one or all processors.
;
; CATEGORY:
;       Pencil Code, File I/O
;
; CALLING SEQUENCE:
;       pc_read_var_raw, object=object, varfile=varfile, tags=tags,   $
;                    datadir=datadir, proc=proc, /allprocs, /quiet,   $
;                    trimall=trimall, swap_endian=swap_endian,        $
;                    f77=f77, time=time, grid=grid
; KEYWORD PARAMETERS:
;    datadir: Specifies the root data directory. Default: './data'.  [string]
;       proc: Specifies processor to get the data from. Default: ALL [integer]
;    varfile: Name of the var file. Default: 'var.dat'.              [string]
;
;     object: Optional structure in which to return the loaded data. [4D-array]
;       tags: Array of tag names inside the object array.            [string(*)]
;
;  /allprocs: Load data from the allprocs directory.
;   /trimall: Remove ghost points from the returned data.
;     /quiet: Suppress any information messages and summary statistics.
;
; EXAMPLES:
;       pc_read_var_raw, obj=vars, tags=tags            ;; read from data/proc*
;       pc_read_var_raw, obj=vars, tags=tags, proc=5    ;; read from data/proc5
;       pc_read_var_raw, obj=vars, tags=tags, /allprocs ;; read from data/allprocs
;
;       cslice, vars
; or:
;       cmp_cslice, { uz:vars[*,*,*,tags.uz], lnrho:vars[*,*,*,tags.lnrho] }
;
; MODIFICATION HISTORY:
;       $Id$
;       Adapted from: pc_read_var.pro, 25th January 2012
;
;-
pro pc_read_var_raw,                                                  $
    object=object, varfile=varfile, datadir=datadir, tags=tags,       $
    dim=dim, param=param, par2=par2, varcontent=varcontent,           $
    proc=proc, allprocs=allprocs, trimall=trimall, quiet=quiet,       $
    swap_endian=swap_endian, f77=f77, time=time, grid=grid

COMPILE_OPT IDL2,HIDDEN
;
; Use common block belonging to derivative routines etc. so we can
; set them up properly.
;
  common cdat,x,y,z,mx,my,mz,nw,ntmax,date0,time0
  common cdat_grid,dx_1,dy_1,dz_1,dx_tilde,dy_tilde,dz_tilde,lequidist,lperi,ldegenerated
  common pc_precision, zero, one
  common cdat_coords,coord_system
;
; Default settings.
;
  default, swap_endian, 0
;
; Default data directory.
;
  if (not keyword_set(datadir)) then datadir=pc_get_datadir()
;
; Name and path of varfile to read.
;
  if (not keyword_set(varfile)) then varfile = 'var.dat'
;
; Check if allprocs is set.
;
  if (keyword_set(allprocs)) then begin
    if (n_elements(proc) ne 0) then message, 'pc_read_var_raw: /allproc and proc cannot be both set.'
    if (not keyword_set(f77)) then f77=0
  endif else begin
    allprocs = 0
  endelse
  default, f77, 1
;
; Get necessary dimensions quietly.
;
  if (n_elements(dim) eq 0) then $
      pc_read_dim, object=dim, datadir=datadir, proc=proc, /quiet
  if (n_elements(param) eq 0) then $
      pc_read_param, object=param, dim=dim, datadir=datadir, /quiet
  if (n_elements(par2) eq 0) then begin
    if (file_test(datadir+'/param2.nml')) then begin
      pc_read_param, object=par2, /param2, dim=dim, datadir=datadir, /quiet
    endif else begin
      print, 'Could not find '+datadir+'/param2.nml'
    endelse
  endif
  if (n_elements(grid) eq 0) then $
      pc_read_grid, object=grid, dim=dim, param=param, datadir=datadir, proc=proc, allprocs=allprocs, /quiet
;
; Set the coordinate system.
;  
  coord_system=param.coord_system
;
; Read dimensions (global)...
;
  if ((n_elements(proc) eq 1) or (allprocs eq 1)) then begin
    procdim=dim
  endif else begin
    pc_read_dim, object=procdim, datadir=datadir, proc=0, /quiet
  endelse
;
; ... and check pc_precision is set for all Pencil Code tools.
;
  pc_set_precision, dim=dim, quiet=quiet
;
; Local shorthand for some parameters.
;
  nx=dim.nx
  ny=dim.ny
  nz=dim.nz
  nw=dim.nx*dim.ny*dim.nz
  mx=dim.mx
  my=dim.my
  mz=dim.mz
  mvar=dim.mvar
  precision=dim.precision
;
; Number of processors over which to loop.
;
  if ((n_elements(proc) eq 1) or (allprocs eq 1)) then begin
    nprocs=1
  endif else if (allprocs eq 2) then begin
    nprocs=dim.nprocz
    procdim.nx=nx
    procdim.ny=ny
    procdim.mx=mx
    procdim.my=my
    procdim.mw=mx*my*procdim.mz
    procdim.ipx=0
    procdim.ipy=0
  endif else begin
    nprocs=dim.nprocx*dim.nprocy*dim.nprocz
  endelse
;
; Initialize / set default returns for ALL variables.
;
  t=zero
  x=fltarr(dim.mx)*one
  y=fltarr(dim.my)*one
  z=fltarr(dim.mz)*one
  dx=zero
  dy=zero
  dz=zero
  deltay=zero
;
  if (nprocs gt 1) then begin
    xloc=fltarr(procdim.mx)*one
    yloc=fltarr(procdim.my)*one
    zloc=fltarr(procdim.mz)*one
  endif
;
;  Read meta data and set up variable/tag lists.
;
  if (n_elements(varcontent) eq 0) then $
      varcontent=pc_varcontent(datadir=datadir,dim=dim,param=param,quiet=quiet)
  totalvars=(size(varcontent))[1]
;
; Initialise read buffers.
;
  if (precision eq 'D') then begin
    object = dblarr (dim.mx, dim.my, dim.mz, totalvars)
    if (nprocs gt 1) then buffer = dblarr (procdim.mx, procdim.my, procdim.mz, totalvars)
  endif else begin
    object = fltarr (dim.mx, dim.my, dim.mz, totalvars)
    if (nprocs gt 1) then buffer = fltarr (procdim.mx, procdim.my, procdim.mz, totalvars)
  endelse
;
; Display information about the files contents.
;
  tag_str = ''
  content = ''
  for iv=0L, totalvars-1L do begin
    if (varcontent[iv].idlvar eq "uu") then begin
      tag_str += ', ux:' + strtrim (iv, 2) + ', uy:' + strtrim (iv+1, 2) + ', uz:' + strtrim (iv+2, 2)
    endif else if (varcontent[iv].idlvar eq "aa") then begin
      tag_str += ', ax:' + strtrim (iv, 2) + ', ay:' + strtrim (iv+1, 2) + ', az:' + strtrim (iv+2, 2)
    endif else begin
      tag_str += ', ' + varcontent[iv].idlvar + ':' + strtrim (iv, 2)
    endelse
    content += ', '+varcontent[iv].variable
    ; For vector quantities skip the required number of elements of the f array.
    iv += varcontent[iv].skip
  endfor
  tag_str = 'tags = { ' + strmid (tag_str, 2) + ' }'
  content = strmid (content, 2)
  if (not keyword_set(quiet)) then begin
    print, ''
    print, 'The file '+varfile+' contains: ', content
    print, ''
    print, 'The grid dimension is ', dim.mx, dim.my, dim.mz
    print, ''
  endif
  if (execute (tag_str) ne 1) then message, 'Error executing: ' + tag_str
;
; Loop over processors.
;
  for i=0,nprocs-1 do begin
;
; Build the full path and filename.
;
    if (allprocs eq 2) then begin
      filename=datadir+'/proc'+str(i*dim.nprocx*dim.nprocy)+'/'+varfile
      procdim.ipz=i
    endif else if (allprocs eq 1) then begin
      filename=datadir+'/allprocs/'+varfile
    endif else begin
      if (n_elements(proc) eq 1) then begin
        filename=datadir+'/proc'+str(proc)+'/'+varfile
      endif else begin
        filename=datadir+'/proc'+str(i)+'/'+varfile
        if (not keyword_set(quiet)) then $
            print, 'Loading chunk ', strtrim(str(i+1)), ' of ', $
            strtrim(str(nprocs)), ' (', $
            strtrim(datadir+'/proc'+str(i)+'/'+varfile), ')...'
        pc_read_dim, object=procdim, datadir=datadir, proc=i, /quiet
      endelse
    endelse
;
; Check for existence and read the data.
;
    if (not file_test(filename)) then begin
      if (arg_present(exit_status)) then begin
        exit_status=1
        print, 'ERROR: cannot find file '+ filename
        close, /all
        return
      endif else begin
        message, 'ERROR: cannot find file '+ filename
      endelse
    endif
;
; Setup the coordinates mappings from the processor to the full domain.
;
    if (nprocs gt 1) then begin
;
;  Don't overwrite ghost zones of processor to the left (and
;  accordingly in y and z direction makes a difference on the
;  diagonals).
;
      if (procdim.ipx eq 0L) then begin
        i0x=0L
        i1x=i0x+procdim.mx-1L
        i0xloc=0L
        i1xloc=procdim.mx-1L
      endif else begin
        i0x=procdim.ipx*procdim.nx+procdim.nghostx
        i1x=i0x+procdim.mx-1L-procdim.nghostx
        i0xloc=procdim.nghostx
        i1xloc=procdim.mx-1L
      endelse
;
      if (procdim.ipy eq 0L) then begin
        i0y=0L
        i1y=i0y+procdim.my-1L
        i0yloc=0L
        i1yloc=procdim.my-1L
      endif else begin
        i0y=procdim.ipy*procdim.ny+procdim.nghosty
        i1y=i0y+procdim.my-1L-procdim.nghosty
        i0yloc=procdim.nghosty
        i1yloc=procdim.my-1L
      endelse
;
      if (procdim.ipz eq 0L) then begin
        i0z=0L
        i1z=i0z+procdim.mz-1L
        i0zloc=0L
        i1zloc=procdim.mz-1L
      endif else begin
        i0z=procdim.ipz*procdim.nz+procdim.nghostz
        i1z=i0z+procdim.mz-1L-procdim.nghostz
        i0zloc=procdim.nghostz
        i1zloc=procdim.mz-1L
      endelse
    endif
;
; Open a varfile and read some data!
;
    openr, file, filename, f77=f77, swap_endian=swap_endian, /get_lun
;
    if (allprocs eq 1) then begin
      ; collectively written files
      readu, file, object
      if (f77 eq 0) then begin
        close, file
        openr, file, filename, /f77, swap_endian=swap_endian
        if (precision eq 'D') then bytes=8 else bytes=4
        point_lun, file, long64(dim.mx*dim.my)*long64(dim.mz*dim.mvar*bytes)
      endif
      readu, file, t, x, y, z, dx, dy, dz
    endif else if (allprocs eq 2) then begin
      ; xy-collectively written files for each ipz-layer
      readu, file, buffer
      if (f77 eq 0) then begin
        close, file
        openr, file, filename, /f77, swap_endian=swap_endian
        if (precision eq 'D') then bytes=8 else bytes=4
        point_lun, file, long64(dim.mx*dim.my)*long64(procdim.mz*dim.mvar*bytes)
      endif
      if (i eq 0) then begin
        readu, file, t
        readu, file, x, y, z, dx, dy, dz
      endif else begin
        t_test = zero
        readu, file, t_test
        if (t ne t_test) then begin
          print, "ERROR: TIMESTAMP IS INCONSISTENT: ", filename
          print, "t /= t_test: ", t, t_test
          print, "Type '.c' to continue..."
          stop
        endif
      endelse
      object[*,*,i0z:i1z,*] = buffer[*,*,i0zloc:i1zloc,*]
    endif else if (nprocs eq 1) then begin
      ; single processor distributed file
      readu, file, object
      if (param.lshear) then begin
        readu, file, t, x, y, z, dx, dy, dz, deltay
      endif else begin
        readu, file, t, x, y, z, dx, dy, dz
      endelse
    endif else begin
      ; multiple processor distributed files
      readu, file, buffer
      if (param.lshear) then begin
        readu, file, t, xloc, yloc, zloc, dx, dy, dz, deltay
      endif else begin
        readu, file, t, xloc, yloc, zloc, dx, dy, dz
      endelse
      if (i eq 0) then begin
        t_test = t
      endif else begin
        if (t ne t_test) then begin
          print, "ERROR: TIMESTAMP IS INCONSISTENT: ", filename
          print, "t /= t_test: ", t, t_test
          print, "Type '.c' to continue..."
          stop
          t = t_test
        endif
      endelse
;
      x[i0x:i1x] = xloc[i0xloc:i1xloc]
      y[i0y:i1y] = yloc[i0yloc:i1yloc]
      z[i0z:i1z] = zloc[i0zloc:i1zloc]
;
; Loop over variables.
; Regular 3-D run.
;
      object[i0x:i1x,i0y:i1y,i0z:i1z,*] = buffer[i0xloc:i1xloc,i0yloc:i1yloc,i0zloc:i1zloc,*]
;
    endelse
    close, file
    free_lun, file
  endfor
;
; Tidy memory a little.
;
  if (nprocs gt 1) then begin
    undefine, xloc
    undefine, yloc
    undefine, zloc
    undefine, buffer
  endif
;
; Remove ghost zones if requested.
;
  if (keyword_set(trimall)) then object = pc_noghost (object, dim=dim)
;
  if (not keyword_set(quiet)) then begin
    print, ' t = ', t
    print, ''
  endif
;
  time = t
  grid = { t:t, x:x, y:y, z:z, dx:dx, dy:dy, dz:dz }
;
end
