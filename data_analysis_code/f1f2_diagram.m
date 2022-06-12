function f1f2_diagram(f1,f2, save, overlay, color)
%F1F2_DIAGRAM Summary of this function goes here
%   Input: F1, F2, save(1,0), overlay, color
%   Output: a F1, F2 vowel placement diagram
if ~overlay
    figure(1)
else
    hold on
    figure(1)
end
scatter(f2, f1 , [], color );
set(gca, 'YDir','reverse');
xlabel('F2 ( Hz )');
ylabel('F1 ( Hz )');

%hold off

path = "./Results/f1f2_diagra_output.png";
if save == 1
    saveas(gcf,path);
end

end

