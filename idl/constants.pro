;
; constants in cgs units
;
  hbar_cgs=1.0545726663d-27 ; [erg*s]
  k_B_cgs=1.38065812d-16    ; [erg/K]
  m_p_cgs=1.672623110d-24   ; [g]
  m_e_cgs=9.109389754d-28   ; [g]
  eV_cgs=1.602177250d-12    ; [erg]
  sigmaH_cgs=4.d-17         ; [cm^2]
  sigmaSB_cgs=5.607d-5      ; [erg/cm^2/s/K^4]
  kappa_es_cgs=3.4d-1       ; [cm^2/g]
;
; derived units
;
  unit_mass=unit_density*unit_length^3
  unit_energy=unit_mass*unit_velocity^2
  unit_time=unit_length/unit_velocity
  unit_flux=unit_energy/(unit_length^2*unit_time)
;
; constants and in code units
;
  if (unit_system eq 'cgs') then begin
    k_B=k_B_cgs/(unit_energy/unit_temperature)
    m_p=m_p_cgs/unit_mass
    m_e=m_e_cgs/unit_mass
    eV=eV_cgs/unit_energy
    sigmaH_=sigmaH_cgs/unit_length^2
    sigmaSB=sigmaSB_cgs/(unit_flux/unit_temperature^4)
    kappa_es=kappa_es_cgs/(unit_length^2/unit_mass)     
  endif else if (unit_system eq 'SI') then begin
    k_B=1e-7*k_B_cgs/(unit_energy/unit_temperature)
    m_p=m_p_cgs*1e-3/unit_mass
    m_e=m_e_cgs*1e-3/unit_mass
    eV=eV_cgs*1e-7/unit_energy
    sigmaH_=sigmaH_cgs*1e-4/unit_length^2
    sigmaSB=sigmaSB_cgs*1e-3/(unit_flux/unit_temperature^4)
    kappa_es=kappa_es_cgs*1e-1/(unit_length^2/unit_mass)
  endif
;
end
