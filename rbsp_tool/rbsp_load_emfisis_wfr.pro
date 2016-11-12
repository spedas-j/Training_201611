;
; PURPOSE: Read RBSP/EMFISIS WFR Lev-2 wave data.
;
; Datatype: 
;    spectra: wave power spectra 
;      FOR rbsp-a_WFR-spectral-matrix-diagonal_emfisis-L2_YYYYMMDD_v?.?.?.cdf
;    spectra-merged: wave power spectra + wave burst 
;      FOR rbsp-a_WFR-spectral-matrix-diagonal-merged_emfisis-L2_YYYYMMDD_v?.?.?.cdf
;!!! spectra-all: wave power spectra 
;      FOR rbsp-a_WFR-spectral-matrix_emfisis-L2_YYYYMMDD_v?.?.?.cdf 
;!!! which contains all off-diagonal components (both real and imaginary parts) 
;!!! as well as the diagonal components. 
; 
; Examples: 
;    rbsp_load_emfisis_wfr, datatype='spectra', probes='a'
;    rbsp_load_emfisis_wfr, datatype='spectra-merged', probes='a' 
;    rbsp_load_emfisis_wfr, datatype='spectra-all', probes='a'
; 
; History:
;    Modified by Kunihiro Keika, November 9, 2016. 
;    Modified by Kunihiro Keika, November 29, 2014. 
;      so that this procedre works on emeifis spectral-matrix data files 
;      that contains off-diagonal spectral matrix. 
;    Prepared by Kunihiro Keika, July 31, 2014. 
;
; Author: 
;    Kunihiro Keika, Univ. Tokyo (keika@eps.s.u-tokyo.ac.jp) 
;
;
;---------------------------------------------------
function read_cdf, file 
; RETURNS DATA IN STRUCTURE 

        print, 'Opening '+file 
        id = CDF_OPEN(file)
        ;info=cdf_info(id)
        ;help,info.vars[12],/st
        inq=cdf_inquire(id)
        if inq.nvars ne 0 then begin
                n=inq.nvars
                if inq.nzvars ne 0 and inq.nzvars gt inq.nvars then begin
                        n=inq.nzvars & zvariable=1
                endif
        endif else if inq.nzvars ne 0 then begin
                zvariable=1
                n=inq.nzvars
        endif

        for i=0L, n-1 do begin
                varinq=cdf_varinq(id,i,zvariable=zvariable)
                if keyword_set(debug) then print, varinq.name, varinq.datatype, format='(2a15)'
                cdf_control, id,get_var_info=info,variable=i,zvariable=zvariable;,set_padvalue=i
                cdf_varget, id, i, var, zvariable=zvariable, rec_count=info.maxrecs+1
                if (i ne 0 ) then dat1=create_struct(dat,varinq.name,var) else dat1=create_struct(varinq.name,var)
                dat=dat1
        endfor
        cdf_close, id
        data=create_struct(dat1,'filename',file)

return, data 
end 
;
;---------------------------------------------------
pro cdf2tplot_wfr, files=files, prefix=prefix  
; This procedure saves all data into tplot variables. 
; INPUT:  
;   files: Name of the files to be loaded. 
; 
   for i=0,n_elements(files)-1 do begin 
      data=read_cdf(files[i]) 

      ;  'Ephemeris Time of the start  of the accumulation for this measurement.'
      epoch=data.epoch
      cdf_epoch, epoch, yr, mo, dy, hr, mn, sc, msc, /BREAK
      ; CONVERT TIME TO TPLOT TIME FORMAT
      tpyr=string(format='(i4.4)',yr)
      tpmo=string(format='(i2.2)',mo)
      tpdy=string(format='(i2.2)',dy)
      tphr=string(format='(i2.2)',hr)
      tpmn=string(format='(i2.2)',mn)
      tpsc=string(format='(i2.2)',sc)
      tpmilli=string(format='(i3.3)',msc)
      ;tptime=dblarr(n_elements(yr))

      tptime_tmp=time_double(tpyr+'-'+tpmo+'-'+tpdy+'/'+tphr+':'+tpmn+':'+tpsc+'.'+tpmilli)
      ;  'The time of the start of the measurement in
      ;   as a UTC time string (CCYY-DOYTHH:MM:SS.hhh)'
      ;bubu_tmp = data.bubu
      bubu_tmp = data.bubu 
      ; BUBU            FLOAT     Array[65, 14400]
      bvbv_tmp = data.bvbv
      ; BVBV            FLOAT     Array[65, 14400]
      bwbw_tmp = data.bwbw
      ; BWBW            FLOAT     Array[65, 14400]
      eueu_tmp = data.eueu
      ; EUEU            FLOAT     Array[65, 14400]
      evev_tmp = data.evev
      ; EVEV            FLOAT     Array[65, 14400]
      ewew_tmp = data.ewew
      ; EWEW            FLOAT     Array[65, 14400]
      wfrbins_tmp = data.wfr_bins
      ; WFR_BINS        UINT      Array[65, 14400]
      wfrbandwidth_tmp = data.wfr_bandwidth
      ; WFR_BANDWIDTH   FLOAT     Array[65, 14400]
      ;wfrfreq_tmp = data.wfr_frequencies  
      wfrfreq_tmp = data.wfr_frequencies  
      ; WFR_FREQUENCIES FLOAT     Array[65, 14400]
      bubv_tmp = data.bubv
      ; BUBV            FLOAT     Array[65, 2, 14400]
      bubw_tmp = data.bubw
      ; BUBW            FLOAT     Array[65, 2, 14400]
      bueu_tmp = data.bueu
      ; BUEU            FLOAT     Array[65, 2, 14400]
      buev_tmp = data.buev
      ; BUEV            FLOAT     Array[65, 2, 14400]
      buew_tmp = data.buew
      ; BUEW            FLOAT     Array[65, 2, 14400]
      bveu_tmp = data.bveu
      ; BVEU            FLOAT     Array[65, 2, 14400]
      bvev_tmp = data.bvev
      ; BVEV            FLOAT     Array[65, 2, 14400]
      bvew_tmp = data.bvew
      ; BVEW            FLOAT     Array[65, 2, 14400]
      bweu_tmp = data.bweu
      ; BWEU            FLOAT     Array[65, 2, 14400]
      bwev_tmp = data.bwev
      ; BWEV            FLOAT     Array[65, 2, 14400]
      bwew_tmp = data.bwew
      ; BWEW            FLOAT     Array[65, 2, 14400]
      euev_tmp = data.euev
      ; EUEV            FLOAT     Array[65, 2, 14400]
      euew_tmp = data.euew
      ; EUEW            FLOAT     Array[65, 2, 14400]
      evew_tmp = data.evew
      ; EVEW            FLOAT     Array[65, 2, 14400]
      bvbw_tmp = data.bvbw
      ; BVBW            FLOAT     Array[65, 2, 14400]
      tpowerb_tmp = data.totalpowerb
      ; TOTALPOWERB     FLOAT     Array[65, 14400]
      tpowere_tmp = data.totalpowere
      ; TOTALPOWERE     FLOAT     Array[65, 14400]
      ;
      lwezgainw_tmp = data.lwezgainw 
      ; LWEZGAINW       INT       Array[1, 14400]
      ; - LWEzGainW -
      ;  Attenuator select indicator for W axis.  0 - Off, 1 - On.   Switches in a 19 dB attenuator.   
      ;  L2 and greater data has the attenuator gains folded into data to provide correct science units.
      ; 
      lwexeygainuv_tmp = data.lwexeygainuv
      ; LWEXEYGAINUV    INT       Array[1, 14400]
      ; - LWExEyGainUV -
      ; Attenuator select indicator for U and V axis.  0 - Off, 1 - On.   Switches in a 19 dB attenuator.  
      ; L2 and greater data has the attenuator gains folded into data to provide correct science units.
      ; 
      scmgain_tmp = data.scmgain
      ; SCMGAIN         INT       Array[1, 14400]
      ; - SCMGain -
      ; Attenuator select indicator for MSC.  0 - Off, 1 - On.   Switches in a 19 dB attenuator.  
      ; L2 and greater data has the attenuator gains folded into data to provide correct science units.
      ; 
      sptt_tmp = data.sptt
      ; SPTT            LONG64    Array[1, 14400]
      met_tmp = data.met
      ; MET             DOUBLE    Array[1, 14400]
      apid_tmp = data.apid
      ; APID            UINT      Array[1, 14400]
   

      ;  'For multiple day data...'
      if i eq 0 then begin
         tptime = tptime_tmp 
         bubu = bubu_tmp 
         bvbv = bvbv_tmp 
         bwbw = bwbw_tmp 
         eueu = eueu_tmp 
         evev = evev_tmp 
         ewew = ewew_tmp 
         wfrbins = wfrbins_tmp 
         wfrbandwidth = wfrbandwidth_tmp 
         wfrfreq = wfrfreq_tmp 
         bubv = bubv_tmp 
         bubw = bubw_tmp 
         bueu = bueu_tmp 
         buev = buev_tmp 
         buew = buew_tmp 
         bveu = bveu_tmp 
         bvev = bvev_tmp 
         bvew = bvew_tmp 
         bweu = bweu_tmp 
         bwev = bwev_tmp 
         bwew = bwew_tmp 
         euev = euev_tmp 
         euew = euew_tmp 
         evew = evew_tmp 
         bvbw = bvbw_tmp 
         tpowerb = tpowerb_tmp 
         tpowere = tpowere_tmp 
         lwezgainw = lwezgainw_tmp
         lwexeygainuv = lwexeygainuv_tmp 
         scmgain = scmgain_tmp 
         sptt = sptt_tmp 
         met = met_tmp 
         apid = apid_tmp 
      endif else begin
         tptime = [tptime, tptime_tmp] 
         bubu = [bubu, bubu_tmp] 
         bvbv = [bvbv, bvbv_tmp] 
         bwbw = [bwbw, bwbw_tmp] 
         eueu = [eueu, eueu_tmp] 
         evev = [evev, evev_tmp] 
         ewew = [ewew, ewew_tmp] 
         wfrbins = [wfrbins, wfrbins_tmp] 
         wfrbandwidth = [wfrbandwidth, wfrbandwidth_tmp] 
         wfrfreq = [wfrfreq, wfrfreq_tmp] 
         bubv = [bubv, bubv_tmp] 
         bubw = [bubw, bubw_tmp] 
         bueu = [bueu, bueu_tmp] 
         buev = [buev, buev_tmp] 
         buew = [buew, buew_tmp] 
         bveu = [bveu, bveu_tmp] 
         bvev = [bvev, bvev_tmp] 
         bvew = [bvew, bvew_tmp] 
         bweu = [bweu, bweu_tmp] 
         bwev = [bwev, bwev_tmp] 
         bwew = [bwew, bwew_tmp] 
         euev = [euev, euev_tmp] 
         euew = [euew, euew_tmp] 
         evew = [evew, evew_tmp] 
         bvbw = [bvbw, bvbw_tmp] 
         tpowerb = [tpowerb, tpowerb_tmp] 
         tpowere = [tpowere, tpowere_tmp] 
         lwezgainw = [lwezgainw, lwezgainw_tmp] 
         lwexeygainuv = [lwexeygainuv, lwexeygainuv_tmp] 
         scmgain = [scmgain, scmgain_tmp] 
         sptt = [sptt, sptt_tmp] 
         met = [met, met_tmp] 
         apid = [apid, apid_tmp] 
      endelse

   endfor 
   ; 
   ; SAVE DATA INTO TPLOT VARIABLES 
   ; 
   wfrfreq = transpose(wfrfreq) 
   wfrfreq = reform(wfrfreq[0,*])  
   ; 
   ; DIAGONAL 
   ; 
   store_data, prefix+'WFR_BuBu', data={x:tptime,y:transpose(bubu),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_BvBv', data={x:tptime,y:transpose(bvbv),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_BwBw', data={x:tptime,y:transpose(bwbw),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_EuEu', data={x:tptime,y:transpose(eueu),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_EvEv', data={x:tptime,y:transpose(evev),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_EwEw', data={x:tptime,y:transpose(ewew),v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   options_wfr_spectra_all, 'BuBu', prefix=prefix 
   options_wfr_spectra_all, 'BvBv', prefix=prefix 
   options_wfr_spectra_all, 'BwBw', prefix=prefix 
   options_wfr_spectra_all, 'EuEu', prefix=prefix 
   options_wfr_spectra_all, 'EvEv', prefix=prefix 
   options_wfr_spectra_all, 'EwEw', prefix=prefix 
   ; OFF-DIAGONAL 
   suf = ['r','i'] 
   for s=0,1 do begin  
      store_data, prefix+'WFR_BuBv_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bubv[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BuBw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bubw[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      store_data, prefix+'WFR_BuEu_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bueu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BuEv_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(buev[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BuEw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(buew[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      store_data, prefix+'WFR_BvEu_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bveu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BvEv_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bveu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BvEw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bveu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      store_data, prefix+'WFR_BwEu_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bweu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BwEv_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bweu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_BwEw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bweu[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      store_data, prefix+'WFR_EuEv_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(euev[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_EuEw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(euew[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      store_data, prefix+'WFR_EvEw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(evew[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      store_data, prefix+'WFR_BvBw_'+suf[s], $ 
                                    data={x:tptime,y:reform(transpose(bvbw[*,s,*])), $ 
                                          v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
                                    dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
      ; 
      ; 
      options_wfr_spectra_all, 'BuBv_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BuBw_'+suf[s], prefix=prefix 
      ; 
      options_wfr_spectra_all, 'BuEu_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BuEv_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BuEw_'+suf[s], prefix=prefix 
      ; 
      options_wfr_spectra_all, 'BvEu_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BvEv_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BvEw_'+suf[s], prefix=prefix 
      ; 
      options_wfr_spectra_all, 'BwEu_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BwEv_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'BwEw_'+suf[s], prefix=prefix 
      ; 
      options_wfr_spectra_all, 'EuEv_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'EuEw_'+suf[s], prefix=prefix 
      options_wfr_spectra_all, 'EvEw_'+suf[s], prefix=prefix 
      ; 
      options_wfr_spectra_all, 'BvBw_'+suf[s], prefix=prefix 
   endfor 

   ;store_data, prefix+'WFR_BuBv', data={x:tptime,y:bubv,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BuBw', data={x:tptime,y:bubw,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

   ;store_data, prefix+'WFR_BuEu', data={x:tptime,y:bueu,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BuEv', data={x:tptime,y:buev,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BuEw', data={x:tptime,y:buew,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

   ;store_data, prefix+'WFR_BvEu', data={x:tptime,y:bveu,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BvEv', data={x:tptime,y:bvev,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BvEw', data={x:tptime,y:bvew,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

   ;store_data, prefix+'WFR_BwEu', data={x:tptime,y:bweu,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BwEv', data={x:tptime,y:bwev,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_BwEw', data={x:tptime,y:bwew,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
    
   ;store_data, prefix+'WFR_EuEv', data={x:tptime,y:euev,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_EuEw', data={x:tptime,y:euew,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   ;store_data, prefix+'WFR_EvEw', data={x:tptime,y:evew,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

   ;store_data, prefix+'WFR_BvBw', data={x:tptime,y:bvbw,v:wfrfreq,v1:wfrbins,v2:wfrbandwidth}, $ 
   ;                               dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

   store_data, prefix+'WFR_TotalPowerB', data={x:tptime,y:tpowerb,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  
   store_data, prefix+'WFR_TotalPowerE', data={x:tptime,y:tpowere,v1:wfrbins,v2:wfrbandwidth}, $ 
                                  dlim={v:'frequency',v1:'frequency bins',v2:'frequency band width'}  

end 
; 
;---------------------------------------------------
function GyroFreq, b, emu, charge
b1=b*10^(-9.);T 
mass=emu*1.67D*10^(-27.);kg
if emu eq -1 then mass=9.1093D*10^(-31.);kg
q=charge*1.6*10^(-19.)

omega=q*b1/mass

return, omega/2./!pi; Hz

end

;---------------------------------------------------
pro options_wfr_spectra_diagonal, tvar, prefix=prefix 
   get_data, prefix+tvar, data=data, dlim=dlim
   store_data, prefix+'WFR_'+tvar, data={x:data.x,y:data.y,v:reform(data.v[0,*])}
   options, prefix+'WFR_'+tvar+'*', 'spec', 1
   options, prefix+'WFR_'+tvar+'*', 'ylog', 1
   options, prefix+'WFR_'+tvar+'*', 'zlog', 1
   options, prefix+'WFR_'+tvar+'*', 'ytitle', tvar
   options, prefix+'WFR_'+tvar+'*', 'ysubtitle', 'Freq [Hz]' 
   options, prefix+'WFR_'+tvar+'*', 'ztitle', dlim.ysubtitle 
   options, prefix+'WFR_'+tvar+'*', 'yrange', 10^[0.,4.] 
   store_data, prefix+'WFR_'+tvar+'_gyro', $ 
           data=[prefix+'WFR_'+tvar, $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_e', $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_e_half', $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_e_tenth', $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_h', $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_he', $ 
                 prefix+'l3_4sec_sm_Magnitude_gyro_o'] 
   options, prefix+'WFR_'+tvar+'*', 'yrange', 10^[0.,4.] 
end 

;---------------------------------------------------
pro options_wfr_spectra_all, tvar, prefix=prefix
   options, prefix+'WFR_'+tvar+'*', 'spec', 1
   options, prefix+'WFR_'+tvar+'*', 'ylog', 1
   options, prefix+'WFR_'+tvar+'*', 'zlog', 1
   options, prefix+'WFR_'+tvar, 'ytitle', tvar
   if strmid(tvar,n_elements(tvar)-1,1) eq 'r' then options, prefix+'WFR_'+tvar, 'ytitle', tvar+'_r'
   if strmid(tvar,n_elements(tvar)-1,1) eq 'i' then options, prefix+'WFR_'+tvar, 'ytitle', tvar+'_i'
   options, prefix+'WFR_'+tvar+'*', 'ysubtitle', 'Freq [Hz]'
;   options, prefix+'WFR_'+tvar+'*', 'ztitle', dlim.ysubtitle
   options, prefix+'WFR_'+tvar+'*', 'yrange', 10^[0.,4.]
   store_data, prefix+'WFR_'+tvar+'_gyro', $
           data=[prefix+'WFR_'+tvar, $
                 prefix+'l3_4sec_sm_Magnitude_gyro_e', $
                 prefix+'l3_4sec_sm_Magnitude_gyro_e_half', $
                 prefix+'l3_4sec_sm_Magnitude_gyro_e_tenth', $
                 prefix+'l3_4sec_sm_Magnitude_gyro_h', $
                 prefix+'l3_4sec_sm_Magnitude_gyro_he', $
                 prefix+'l3_4sec_sm_Magnitude_gyro_o']
   options, prefix+'WFR_'+tvar+'*', 'yrange', 10^[0.,4.]
end

;---------------------------------------------------
pro rbsp_load_emfisis_wfr, datatype=datatype, probes=probes, level=level

if not keyword_set(level) then level='l2' 

rbsp_emfisis_init 

for i=0, n_elements(probes)-1 do begin 
    probe = probes[i] 
    source = file_retrieve(/struct) 
    ;source.local_data_dir = root_data_dir()+'rbsp/rbsp'+probe+'/emfisis/fr/'  
    ;source.local_data_dir = root_data_dir()+'rbsp/emfisis/Flight/rbsp'+probe+'/'  
    source.local_data_dir = root_data_dir()+'rbsp/emfisis/Flight/RBSP-'+strupcase(probe)+'/'  
    source.remote_data_dir = 'http://emfisis.physics.uiowa.edu/Flight/RBSP-'+strupcase(probe)+'/'

    if datatype eq 'spectra' then $ 
               pathformat = strupcase(level)+'/YYYY/MM/DD/rbsp-'+probe $ 
               + '_WFR-'+datatype+'l-matrix-diagonal_emfisis-' $ 
               + strupcase(level) + '_YYYYMMDD_v?.?.?.cdf' $ 
    else if datatype eq 'spectra-merged' then $ 
               pathformat = strupcase(level)+'/YYYY/MM/DD/rbsp-'+probe $ 
               + '_WFR-spectral-matrix-diagonal-merged_emfisis-' $ 
               + strupcase(level) + '_YYYYMMDD_v?.?.?.cdf' $ 
    else if datatype eq 'spectra-all' then $ 
               pathformat = strupcase(level)+'/YYYY/MM/DD/rbsp-'+probe $ 
               + '_WFR-spectral-matrix_emfisis-' $ 
               + strupcase(level) + '_YYYYMMDD_v?.?.?.cdf'  
                
  
    relpathnames = file_dailynames(file_format=pathformat)
    if keyword_set(continuous) then $ 
        relpathnames = file_dailynames(file_format=pathformat,/hour_res)
  
    ; Download CDF files if they are updated. 
    files = file_retrieve(relpathnames, _extra=source, /last_version)

    ; Read CDF files 
    prefix = 'rbsp'+probe+'_emfisis_' ;Prefix for tplot variable name
    if datatype eq 'spectra-all' then cdf2tplot_wfr, file=files, prefix=prefix $ 
       else cdf2tplot,file=files,verbose=source.verbose,prefix=prefix 

    ;---GYROFREQ---(USE 4-SEC FLUXGATE MAGNETOMETER DATA)---
    rbsp_load_emfisis, level='l3', cadence='4sec', coord='sm', probe=probe
    tvar_gyro = 'rbsp'+probe+'_emfisis_l3_4sec_sm_Magnitude' 
    get_data, tvar_gyro, data=data 
    gyrofreq_h=gyrofreq(data.y,1,1)
    gyrofreq_he=gyrofreq(data.y,4,1)
    gyrofreq_o=gyrofreq(data.y,16,1)
    gyrofreq_e=gyrofreq(data.y,-1,1)
    gyrofreq_e_half=gyrofreq(data.y,-1,1)/2. 
    gyrofreq_e_tenth=gyrofreq(data.y,-1,1)/10. 
    store_data, tvar_gyro+'_gyro_h', data={x:data.x,y:gyrofreq_h}, dlim={colors:0}  
    store_data, tvar_gyro+'_gyro_he', data={x:data.x,y:gyrofreq_he}, dlim={colors:0}  
    store_data, tvar_gyro+'_gyro_o', data={x:data.x,y:gyrofreq_o}, dlim={colors:0}  
    store_data, tvar_gyro+'_gyro_e', data={x:data.x,y:gyrofreq_e}, dlim={colors:5}  
    store_data, tvar_gyro+'_gyro_e_half', data={x:data.x,y:gyrofreq_e_half}, dlim={colors:5}  
    store_data, tvar_gyro+'_gyro_e_tenth', data={x:data.x,y:gyrofreq_e_tenth}, dlim={colors:5}  
    ;---OPTIONS---
    if datatype ne 'spectra-all' then begin 
       options_wfr_spectra_diagonal, 'BuBu', prefix=prefix 
       options_wfr_spectra_diagonal, 'BvBv', prefix=prefix 
       options_wfr_spectra_diagonal, 'BwBw', prefix=prefix 
       options_wfr_spectra_diagonal, 'EuEu', prefix=prefix 
       options_wfr_spectra_diagonal, 'EvEv', prefix=prefix 
       options_wfr_spectra_diagonal, 'EwEw', prefix=prefix 
    endif 
    ;---TPLOT---
       tplot_names
       if datatype eq 'spectra' then $ 
          window, 0, xsize=800., ysize=1000. 
          tplot, prefix + ['*_B?B?','*_E?E?'] + '_gyro'  

endfor 
end 

