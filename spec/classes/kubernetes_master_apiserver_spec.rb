require 'spec_helper'

describe 'kubernetes::master::apiserver', :type => :class do
  context 'with defaults for all parameters on RedHat' do
    describe 'with minimum_version default' do
      let :facts do
        {
          :kernel   => 'Linux',
          :osfamily => 'RedHat',
        }
      end

      let :params do
        {
          :service_cluster_ip_range      => '1.1.1.1',
        }
      end

      it 'test default install' do
        is_expected.to compile.with_all_deps
        is_expected.to contain_class('kubernetes::master')
        is_expected.to contain_class('kubernetes::master::apiserver')
        is_expected.to contain_class('kubernetes::master::params')

        is_expected.to contain_file('/etc/kubernetes/etcd_config.json')
        is_expected.to contain_file('/etc/kubernetes/apiserver').with({  'ensure'  => 'file',  })
        is_expected.to contain_file('/etc/kubernetes/apiserver').with_content(/### file managed by puppet/)
        should contain_service('kube-apiserver')
      end
    end

    describe 'with minimum_version 1.2' do
      let :params do
        {
          :service_cluster_ip_range  => '1.1.1.1',
          :minimum_version           => '1.2',
        }
      end

      it 'test with param minimum_version set to 1.2' do
        is_expected.to_not contain_file('/etc/kubernetes/etcd_config.json')
      end
    end
  end
end
