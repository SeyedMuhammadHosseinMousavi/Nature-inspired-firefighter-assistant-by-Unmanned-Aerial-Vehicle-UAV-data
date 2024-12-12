
fff=imread("cc.jpg");
fff=im2gray(fff);
[ im_enhanced,enhancement_lut,best_fitness,pheromone_map,best_chromosome,fitness_per_iteration,last_enhancing_part,elapsed_time ] = imenhance( fff,100,'no_sa' )