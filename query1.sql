select 
  E.ANOMES, 
  E.CPF_CRIP, 
  E.NUMBERX_CRIPT, 
  E.CACCSERNO_CRIPT, 
  E.CD_EMPRESA, 
  E.QTD_ITEMCUPOM, 
  E.VL_SOMATOTALITEM, 
  E.rsac_fl_ativo, 
  max(E.RSAC_DATE_REF) MAX_DATE_REF_PROBE 
FROM 
  (
    SELECT 
      C.ANOMES, 
      C.CPF_CRIP, 
      C.NUMBERX_CRIPT, 
      C.CACCSERNO_CRIPT, 
      C.CD_EMPRESA, 
      C.QTD_ITEMCUPOM, 
      C.VL_SOMATOTALITEM, 
      d.rsac_fl_ativo, 
      d.RSAC_DATE_REF 
    FROM 
      (
        SELECT 
          A.ANOMES, 
          A.CPF_CRIP, 
          B.NUMBERX_CRIPT, 
          B.CACCSERNO_CRIPT, 
          B.CD_EMPRESA, 
          A.QTD_ITEMCUPOM, 
          A.VL_SOMATOTALITEM 
        FROM 
          (
            SELECT 
              ANOMES, 
              CPF_CRIP, 
              QTD_ITEMCUPOM, 
              VL_SOMATOTALITEM 
            FROM 
              (
                SELECT 
                  ANOMES, 
                  CPF_CRIP, 
                  COUNT(TICU_ID_ITEMCUPOM) AS QTD_ITEMCUPOM, 
                  SUM(TICU_VL_TOTALITEM) AS VL_SOMATOTALITEM 
                FROM 
                  EVE_BUFFER_CCI_MANU_HCKT 
                GROUP BY 
                  ANOMES, 
                  CPF_CRIP 
                ORDER BY 
                  ANOMES, 
                  QTD_ITEMCUPOM
              ) 
              ) A 
          INNER JOIN (
            SELECT 
              NUMBERX_CRIPT, 
              CACCSERNO_CRIPT, 
              CPF_CRIP, 
              CD_EMPRESA 
            FROM 
              EVE_CHAVES_MANU_HCKT
          ) B ON B.CPF_CRIP = A.CPF_CRIP 
        ORDER BY 
          
          A.VL_SOMATOTALITEM DESC
      ) C 
      INNER JOIN EVE_PROBE_MANU_HCKT D ON C.NUMBERX_CRIPT = D.NUMBERX_CRIPT 
      AND C.anomes = d.cd_posicao
  ) E 
group by 
  E.ANOMES, 
  E.CPF_CRIP, 
  E.NUMBERX_CRIPT, 
  E.CACCSERNO_CRIPT, 
  E.CD_EMPRESA, 
  E.QTD_ITEMCUPOM, 
  E.VL_SOMATOTALITEM, 
  E.rsac_fl_ativo