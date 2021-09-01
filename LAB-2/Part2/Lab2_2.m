load('lab2_2_data.mat')
N=size(p0,1);

W=zeros(N,N);
mu={p0,p1,p2};
state=zeros(N,1);
M=size(mu,2);
images=3;
distortion=[0.05,0.1,0.25];
for i=1:images
    for j=1:numel(distortion)
        distorted_image=distort_image(mu{i},distortion(j));
        
        [states,energies,overlaps]=Hopfield(mu,distorted_image);
        
        img1=reshape(mu{i},32,32);
        img2=reshape(distorted_image,32,32);
        img3=reshape(states{end},32,32);
        fig1=figure
        subplot(1,2,1);
        imagesc(img2);
        title("Distorted Image");
        
        subplot(1,2,2);
        imagesc(img3);
        title("Reconstructed Image. MSE = "+mse(img1,img3));
        folder=pwd;
        saveas(fig1,[folder,sprintf('/plots/distorted_%d_%d_reconstructed.fig',i,distortion(j))])

        img4=(img3+img2)/2;
        for x=1:32
            for y=1:32
                if img4(x,y)==-1
                    img4(x,y)=0;
                end
            end
        end
        for x=1:32
            for y=1:32
                if img4(x,y)==1
                    img4(x,y)=-1;
                end
            end
        end
        img4=img4+(img3-img2);
        for x=1:32
            for y=1:32
                if img4(x,y)==2
                    img4(x,y)=1;
                end
            end
        end
        fig2=figure
        
        imagesc(img4);
        title("Differences");
        mymap = [convert_from_rgb(237),convert_from_rgb(41),convert_from_rgb(57)
            
        0.81640625, 0.8828125, 0.19140625
        0,convert_from_rgb(171),convert_from_rgb(102)
        0.27734375,0.27734375,0.27734375
        
        ];
    colormap(mymap);
    cLims = [-2 1];
    
    cb = colorbar; %// This time we need a handle to the colorbar
    cb.Ticks = (cLims(1):cLims(2)); %// Set the tick positions
    cb.TickLabels =["Removed Noise";"Original";"Untouched";"Added from memory"];  %// Set the tick strings
    axis image;
    %%%%%%%%%%%%%%%%%%
    saveas(fig2,[folder,sprintf('/plots/distorted_%d_%d_reconstructed_differences.fig',i,distortion(j))])
    fig3=figure
    plot(1:size(overlaps,2),overlaps)
    title("Overlaps")
    saveas(fig3,[folder,sprintf('/plots/distorted_%d_%d_overlaps.fig',i,distortion(j))])
    
    fig4=figure
    plot(1:size(energies,2),energies)
    title("Energies")
    saveas(fig4,[folder,sprintf('/plots/distorted_%d_%d_energies.fig',i,distortion(j))])
    
    end
end


function rgb =convert_from_rgb(value)
rgb=value/256;
end