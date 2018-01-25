function opt_bubbleplot(C,ns_bank,ep_bank,do_new_figure,closest)

% opt_bubbleplot makes a bubble plot representing the final optimisation
% results. It's used by opt_eval function.
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

[n,w] = sort(-C(:,1));
Cplot = C(w,:);
if closest > 0; closest = find(w == closest); end
if do_new_figure; figure; set(gcf,'color','white'); end
hold on
maxsize = 34;
minsize = 12;
xrange = max(Cplot(:,3)) - min(Cplot(:,3));
yrange = max(Cplot(:,4)) - min(Cplot(:,4));
if xrange == 0; xrange = 0.1; end
if yrange == 0; yrange = 0.1; end
xmax = max(Cplot(:,3)) + xrange/10;
ymax = max(Cplot(:,4)) + yrange/10;
xmin = min(Cplot(:,3)) - xrange/10;
ymin = min(Cplot(:,4)) - yrange/10;
ylim = [ymin ymax];
xlim = [xmin xmax];
line([mean(Cplot(:,3));mean(Cplot(:,3))],ylim,'linestyle',':','Color','k')
line(xlim,[mean(Cplot(:,4));mean(Cplot(:,4))],'linestyle',':','Color','k')
for i=1:size(Cplot,1)
    plotbubble(Cplot(i,:),ns_bank,ep_bank,maxsize,minsize)
end
if closest > 0; plotbubble(Cplot(closest,:),ns_bank,ep_bank,maxsize,minsize,'r'); end
hold off
axis([xlim ylim])
xlabel('relative frequency')
ylabel('mean of optimisatiion criteria')
box on;

% -------------------------------------------------------------------------
function plotbubble(xin,ns_bank,ep_bank,maxsize,minsize,colcode)

ns = xin(1);
ep = xin(2);
nsscal = (ns - min(ns_bank))/(max(ns_bank) - min(ns_bank));
sizescal = nsscal*(maxsize-minsize) + minsize;
epscal = (ep - min(ep_bank))/(max(ep_bank) - min(ep_bank));
colorscal = 1-epscal;
if nargin < 6
    color_here = [colorscal colorscal 1];
else
    color_here = colcode;
end
plot(xin(3),xin(4),'o','MarkerEdgeColor','k','MarkerSize',sizescal,'MarkerFaceColor',color_here)