function liverSSu=erodeDilate(liverSS,erodeV,dilateV)

liverSSu=uint8(liverSS);

liverSSu=imerode(liverSSu,true(erodeV,erodeV));

liverSSu=pickLargestRegion(liverSSu);

liverSSu=imdilate(liverSSu,true(dilateV,dilateV));

end


