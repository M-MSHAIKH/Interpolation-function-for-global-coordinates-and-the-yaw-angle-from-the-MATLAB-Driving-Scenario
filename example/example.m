[ref_elip, t_inter] = WaypointsInter(@createDrivingScenarioElliptical, 0.01);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This example shows how to use the the WaypointsInter function for
% interpolatting the non unifrom data with defined sampling time in sec.

% This file also illustate the evaluation of vehicle global position as
% time passes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


gifFile = 'animation.gif';
skip = 5;   % use every 5th frame

figure; hold on;
plot(ref_elip(:,1), ref_elip(:,2), 'b-', 'LineWidth', 1.5);
p = plot(NaN, NaN, 'r.', 'MarkerSize', 40);

xlim([min(ref_elip(:,1))-10, max(ref_elip(:,1))+10]);
ylim([min(ref_elip(:,2))-10, max(ref_elip(:,2))+10]);
xlabel("Global Longitudinal Position (m)")
ylabel("Global Lateral Position (m)")

for t = 1:skip:length(t_inter)
    set(p, 'XData', ref_elip(t,1), 'YData', ref_elip(t,2));
    title(sprintf('Time in sec: %.2f', t_inter(t)));
    drawnow;

    frame = getframe(gcf);
    img = frame2im(frame);
    [imind,cm] = rgb2ind(img,256);
    if t == 1
        imwrite(imind, cm, gifFile, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, gifFile, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end