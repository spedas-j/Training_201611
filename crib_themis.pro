; = = = = Load and plot THEMIS FGM, ESA, and SST data = = = = 
;
;Set time range 
thm_init 
timespan, '2013-07-25', 1, /day  

;Load THEMIS E Spin-fit magnetic field data 
thm_load_fgm, probe='e', coord='gsm', datatype='fgs', level='l2'  
cotrans, 'the_fgs_gsm', 'the_fgs_sm', /GSM2SM 

;Load THEMIS E ESA data 
thm_load_esa, level='l2', probe='e'

;Load THEMIS E SST data 
thm_load_sst, probe='e', level='l2'

;PLOT downloaded THEMIS data 
tvar =['the_fgs_sm', $
      'the_psef_en_eflux', $
      'the_peer_en_eflux', $
      'the_psif_en_eflux', $
      'the_peir_en_eflux'] 
tplot, tvar, title = 'THEMIS data', trange='2013-07-25/'+['20:00','24:00'] 
 
; 
end 

