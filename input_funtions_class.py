class hicCorrelateParams:
    """ functions for providing inputs and parameters for hicCorrelate """
    def __init__(self):
        self.data = []
        self.batch = []
        self.sample = []
        self.labels = []


    def h5PerBatch(self, units, wildcards):
        """function for fetching h5 matrix files per batch"""
        for index, row in units[units.batch == wildcards["batch"]].iterrows():
            self.labels.append(row['sample_id'])
            self.batch.append("/".join(["hicexplorer/hicBuildMatrix",
                                        wildcards["subcommand"],
                                        row['batch'],
                                        row['sample_id'],
                                        row['sample_id']]) + "_" + "_".join([row['lane'], str(row['replicate']), "hic_matrix.h5"]))
        
    def h5PerSample(self, units, wildcards):
        """function for fetching h5 matrix files per sample"""
        for index, row in units[units.sample_id == wildcards["sample"]].iterrows():
            self.labels.append(row['batch'])
            self.sample.append("/".join(["hicexplorer/hicBuildMatrix",
                                         wildcards["subcommand"],
                                         row['batch'],
                                         row['sample_id'],
                                         row['sample_id']]) + row['lane'] + "_" + str(row['replicate']) + "_hic_matrix.h5")
